import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';
import 'package:wav/wav.dart';

import 'package:bckgrnd/ppln/transcribe/whisper_params.dart';
import 'package:bckgrnd/ppln/transcribe/transcribe_status.dart';

// TODO: profile on iOS
// TODO: try vosk package
class WhisperController {
  TranscribeStatus? _transcribeStatus;

  // TODO: make sure it is only triggered from the same thread.
  Future<void> transcribe({
    required final String filePath,
    required final WhisperParams params,
    required final void Function(TranscribeStatus transcribeStatus) onStarted,
    required final void Function(TranscribeStatus transcribeStatus) onFinished,
  }) async {
    assert(_transcribeStatus == null);
    final whisper = Whisper(
      model: params.model,
      downloadHost: 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main',
    );
    // const whisper = Whisper(
    //     model: WhisperModel("tiny.en-tdrz"),
    //     downloadHost:
    //         "https://huggingface.co/akashmjn/tinydiarize-whisper.cpp");

    // TODO: Add better heuristic to determine the number of cores.
    const availableCores = 6;
    const threads = availableCores;
    final whisperVersion = await whisper.getVersion();

    if (kDebugMode) {
      debugPrint('[Whisper] Assumed number of cores = $availableCores');
      debugPrint('[Whisper] Whisper version = $whisperVersion');
    }

    _transcribeStatus = TranscribeStatus.started();
    onStarted(_transcribeStatus!);

    if (kDebugMode) {
      debugPrint('[Whisper] Checking audio');
      await checkAudio(filePath);
    }

    final transcription = await whisper.transcribe(
      transcribeRequest: TranscribeRequest(
        audio: filePath,
        language: params.lang,
        nProcessors: availableCores,
        threads: threads,
        isTranslate: params.translate,
        isNoTimestamps: !params.withSegments,
        splitOnWord: params.splitWords,
        diarize: params.diarize,
        speedUp: params.speedUp,
      ),
    );

    final transcribeResultStatus = _transcribeStatus!.finished(transcription);
    _transcribeStatus = null;
    onFinished(transcribeResultStatus);
  }

  static Future<void> checkAudio(final String filePath) async {
    if (!kDebugMode) {
      return;
    }

    assert(await File(filePath).exists());

    final wav = await Wav.readFile(filePath);
    assert(wav.samplesPerSecond == 16000);
    assert(wav.format == WavFormat.pcm16bit);
  }
}
