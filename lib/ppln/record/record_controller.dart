import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:bckgrnd/ppln/record/record_params.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:bckgrnd/ppln/record/record_status.dart';
import 'package:bckgrnd/ppln/record/record_vad.dart';

// TODO: diarization
// TODO: voice identification
class RecordController {
  RecordController({
    required this.onChunkStarted,
    required this.onChunkFinished,
  });

  final void Function(RecordStatus recordStatus) onChunkStarted;
  final void Function(RecordStatus recordStatus) onChunkFinished;

  AudioRecorder? _recorder;
  int _chunkCounter = 0;
  RecordStatus? _currentChunkRecordStatus;
  Timer? _timer;
  RecordVad? _vad;
  RecordParams? _params;

  Future<void> startRecording(final RecordParams params) async {
    _params = params;
    _recorder = AudioRecorder();
    debugPrint(
        '[RecordConotroller] input devices: ${await _recorder!.listInputDevices()}');
    assert(await _recorder!.isEncoderSupported(AudioEncoder.pcm16bits));

    _chunkCounter = 0;
    _vad = RecordVad(
      vadAmplitudeThresholdDb: _params!.vadAmplitudeThresholdDb,
      vadMeasurePeriodMs: _params!.vadMeasurePeriodMs,
      speechToSilenceDurationThresholdSec:
          _params!.speechToSilenceDurationThresholdSec,
      onSilence: _startNextChunk,
    );

    await _recordChunk();
  }

  Future<void> _recordChunk() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final chunkPath = '${appDirectory.path}/chunk_$_chunkCounter.wav';

    await _recorder!.start(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _params!.sampleRate,
        numChannels: _params!.numChannels,
        autoGain: _params!.autoGain,
        echoCancel: _params!.echoCancel,
        noiseSuppress: _params!.noiseSuppress,
      ),
      path: chunkPath,
    );
    _currentChunkRecordStatus = RecordStatus.started(chunkPath);
    onChunkStarted(_currentChunkRecordStatus!);

    _timer = Timer(_params!.maxChunkDuration, _startNextChunk);
  }

  Future<void> _finishChunk() async {
    _timer?.cancel();
    await _recorder!.stop();
    _timer = null;

    if (Platform.isAndroid) {
      await addWavHeader(_currentChunkRecordStatus!.filePath);
    }

    onChunkFinished(_currentChunkRecordStatus!.stopped(
      silenceStartedTime: _vad!.silenceStartedTime,
    ));
    _currentChunkRecordStatus = null;
  }

  Future<void> _startNextChunk() async {
    await _finishChunk();
    _chunkCounter++;
    await _recordChunk();
  }

  Future<void> stopRecording() async {
    debugPrint('[RecordController] stopping');
    await _finishChunk();
    debugPrint('[RecordController] stopped');

    await _recorder!.dispose();
    await _vad!.stop();
  }

  Future<void> addWavHeader(
    final String rawPcmPath, {
    final String? wavOutputFilePath,
    final Duration? debugDuration,
  }) async {
    if (debugDuration != null) {
      await debugPrintRawPcmData(rawPcmPath, debugDuration);
    }

    final wavFilePath = wavOutputFilePath ?? rawPcmPath;
    final rawPcmFile = File(rawPcmPath);
    final rawPcmData = await rawPcmFile.readAsBytes();

    // Recording settings
    const channels = 1;
    const sampleRate = 16000;
    const bitsPerSample = 16;
    const byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    const blockAlign = channels * bitsPerSample ~/ 8;
    final subchunk2Size = rawPcmData.length;
    final chunkSize = 36 + subchunk2Size;

    final header = ByteData(44);
    var offset = 0;

    // ChunkID 'RIFF'
    header.setUint8(offset++, 'R'.codeUnitAt(0));
    header.setUint8(offset++, 'I'.codeUnitAt(0));
    header.setUint8(offset++, 'F'.codeUnitAt(0));
    header.setUint8(offset++, 'F'.codeUnitAt(0));

    // ChunkSize
    header.setUint32(offset, chunkSize, Endian.little);
    offset += 4;

    // Format 'WAVE'
    header.setUint8(offset++, 'W'.codeUnitAt(0));
    header.setUint8(offset++, 'A'.codeUnitAt(0));
    header.setUint8(offset++, 'V'.codeUnitAt(0));
    header.setUint8(offset++, 'E'.codeUnitAt(0));

    // Subchunk1ID 'fmt '
    header.setUint8(offset++, 'f'.codeUnitAt(0));
    header.setUint8(offset++, 'm'.codeUnitAt(0));
    header.setUint8(offset++, 't'.codeUnitAt(0));
    header.setUint8(offset++, ' '.codeUnitAt(0));

    // Subchunk1Size (16 for PCM)
    header.setUint32(offset, 16, Endian.little);
    offset += 4;

    // AudioFormat (1 for PCM)
    header.setUint16(offset, 1, Endian.little);
    offset += 2;

    // NumChannels
    header.setUint16(offset, channels, Endian.little);
    offset += 2;

    // SampleRate
    header.setUint32(offset, sampleRate, Endian.little);
    offset += 4;

    // ByteRate
    header.setUint32(offset, byteRate, Endian.little);
    offset += 4;

    // BlockAlign
    header.setUint16(offset, blockAlign, Endian.little);
    offset += 2;

    // BitsPerSample
    header.setUint16(offset, bitsPerSample, Endian.little);
    offset += 2;

    // Subchunk2ID 'data'
    header.setUint8(offset++, 'd'.codeUnitAt(0));
    header.setUint8(offset++, 'a'.codeUnitAt(0));
    header.setUint8(offset++, 't'.codeUnitAt(0));
    header.setUint8(offset++, 'a'.codeUnitAt(0));

    // Subchunk2Size
    header.setUint32(offset, subchunk2Size, Endian.little);
    offset += 4;

    // Combine header and raw PCM data
    final wavData = BytesBuilder();
    wavData.add(header.buffer.asUint8List());
    wavData.add(rawPcmData);

    // Save the new WAV file
    final wavFile = File(wavFilePath);
    await wavFile.writeAsBytes(wavData.toBytes());
  }

  Future<void> debugPrintRawPcmData(
    final String rawPcmPath,
    final Duration duration,
  ) async {
    final rawPcmFile = File(rawPcmPath);
    if (!await rawPcmFile.exists()) {
      throw Exception(
          '[RecordController] Raw PCM file does not exist at path: $rawPcmPath');
    }

    final rawPcmData = await rawPcmFile.readAsBytes();
    if (rawPcmData.isEmpty) {
      throw Exception('[RecordController] Raw PCM data is empty.');
    }

    debugPrint(
        '[RecordController] Raw PCM data size: ${rawPcmData.length} bytes');

    const channels = 1;
    const sampleRate = 16000;
    const bitsPerSample = 16;
    const byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final expectedSize = duration.inMilliseconds * byteRate ~/ 1000;
    final pcmSamples = Int16List.view(rawPcmData.buffer);
    final numSamples = pcmSamples.length;
    debugPrint('[RecordController] Number of samples: $numSamples');
    debugPrint('[RecordController] expected size: $expectedSize bytes');
    final minSample = pcmSamples.reduce((final a, final b) => a < b ? a : b);
    final maxSample = pcmSamples.reduce((final a, final b) => a > b ? a : b);
    debugPrint('[RecordController] value range: [$minSample, $maxSample]');
    final leadingZeros = rawPcmData.indexWhere((final e) => e > 0);
    debugPrint('[RecordController] leadingZeros: $leadingZeros');
    final trailingZeros =
        rawPcmData.length - rawPcmData.lastIndexWhere((final e) => e > 0);
    debugPrint('[RecordController] trailingZeros: $trailingZeros');
    final zeros = rawPcmData.where((final e) => e > 0).length;
    debugPrint('[RecordController] zeros: $zeros');
    for (var i = 0; i < 20; i++) {
      debugPrint('[RecordController] Sample $i: ${rawPcmData[i]}');
    }
  }
}
