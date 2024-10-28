import 'dart:async';

import 'package:bckgrnd/ppln/ppln_status.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';
import 'package:bckgrnd/ppln/record/record_controller.dart';
import 'package:bckgrnd/ppln/record/record_status.dart';
import 'package:bckgrnd/ppln/transcribe/transcribe_status.dart';
import 'package:bckgrnd/ppln/transcribe/whisper_controller.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:bckgrnd/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

// TODO: create pipeline: pipeline_plus
class PplnController {
  PplnController({required this.onStatusChange, required this.params}) {
    _recordController = RecordController(
      onChunkStarted: _onChunkRecordStarted,
      onChunkFinished: _onChunkRecordFinished,
    );
  }

  final void Function(PplnStatus) onStatusChange;
  PplnParams params;

  final List<PplnSegmentStatus> _segmentsQueue = [];
  // TODO: find better way of prioritizing next segment.
  int get _segmentToProcessId => _segmentsQueue.indexWhere(
      (final segment) => segment.state == PplnSegmentState.recorded);
  int get _segmentInProcessingId => _segmentsQueue.indexWhere(
      (final segment) => segment.state == PplnSegmentState.transcribing);

  late final RecordController _recordController;
  final WhisperController _whisperController = WhisperController();

  bool _isRecording = false;
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> start() async {
    _isRecording = true;
    try {
      await _recordController.startRecording(params.recordParams);
    } catch (e, stack) {
      _errorMessage = '$e :: $stack';
      _updateStatus();
    }
  }

  Future<void> _onChunkRecordStarted(
    final RecordStatus chunkRecordStatus,
  ) async {
    _segmentsQueue.add(PplnSegmentStatus.fromRecord(chunkRecordStatus));
    await Storage.instance.put(_segmentsQueue.last);
    _updateStatus();
  }

  Future<void> _onChunkRecordFinished(
      final RecordStatus chunkRecordStatus) async {
    assert(_segmentsQueue.last.recordStatus.startTime ==
        chunkRecordStatus.startTime);

    _segmentsQueue.last = PplnSegmentStatus.fromRecord(chunkRecordStatus);
    if (_segmentsQueue.last.recordStatus.isSilent!) {
      if (_segmentsQueue.length > 1 &&
          _segmentsQueue[_segmentsQueue.length - 2].recordStatus.isSilent!) {
        // Merging last 2 silent segments segment.
        _segmentsQueue.removeLast();
        _segmentsQueue.last = PplnSegmentStatus.fromRecord(
            _segmentsQueue.last.recordStatus.mergeSilent(chunkRecordStatus));
      }

      // Finishing transcription immediately for silent recording.
      final transcribeStatus = TranscribeStatus.started().finished(
        WhisperTranscribeResponse.fromJson({
          '@type': 'transcribed',
          'text': '[silence]',
        }),
      );
      _segmentsQueue.last =
          _segmentsQueue.last.withTranscribeStatus(transcribeStatus);
    }
    await Storage.instance.put(_segmentsQueue.last);
    // TODO: Make unawaited?
    await _processQueue();
    _updateStatus();
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _segmentToProcessId == -1) {
      return;
    }

    _isProcessing = true;
    _errorMessage = null;
    _updateStatus();

    while (_segmentToProcessId != -1) {
      try {
        await _whisperController.transcribe(
          filePath: _segmentsQueue[_segmentToProcessId].recordStatus.filePath,
          params: params.whisperParams,
          onStarted: _onTranscribeStarted,
          onFinished: _onTranscribeFinished,
        );
      } catch (e, stack) {
        _errorMessage = '$e :: $stack';
        debugPrint('Transcription Error: $_errorMessage');
        break;
      }
    }

    _isProcessing = false;
    _updateStatus();
  }

  Future<void> _onTranscribeStarted(
    final TranscribeStatus transcribeStatus,
  ) async {
    final segmentId = _segmentToProcessId;
    assert(_segmentsQueue[segmentId].transcribeStatus == null);
    _segmentsQueue[segmentId] =
        _segmentsQueue[segmentId].withTranscribeStatus(transcribeStatus);
    await Storage.instance.put(_segmentsQueue.last);
    _updateStatus();
  }

  Future<void> _onTranscribeFinished(
    final TranscribeStatus transcribeStatus,
  ) async {
    final segmentId = _segmentInProcessingId;
    assert(_segmentsQueue[segmentId].transcribeStatus!.startTime ==
        transcribeStatus.startTime);
    _segmentsQueue[segmentId] =
        _segmentsQueue[segmentId].withTranscribeStatus(transcribeStatus);
    await Storage.instance.put(_segmentsQueue.last);
    // await File(outputPath).delete();
    _updateStatus();
  }

  Future<void> stop() async {
    _isRecording = false;
    try {
      await _recordController.stopRecording();
      assert(_segmentsQueue.last.recordStatus.finished);
    } catch (e, stack) {
      _errorMessage = '$e :: $stack';
      _updateStatus();
    }
  }

  Future<void> addAudioFile(final String filePath) async {
    _segmentsQueue.add(PplnSegmentStatus.fromRecord(
        RecordStatus.started(filePath).stopped(silenceStartedTime: null)));
    await Storage.instance.put(_segmentsQueue.last);

    await _processQueue();
  }

  void _updateStatus() {
    onStatusChange(
      PplnStatus(
        isRecording: _isRecording,
        isProcessing: _isProcessing,
        segments: List.unmodifiable(_segmentsQueue),
        error: _errorMessage,
      ),
    );
  }
}
