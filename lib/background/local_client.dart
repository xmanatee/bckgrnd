import 'dart:async';
import 'dart:collection';

import 'package:bckgrnd/background/client.dart';
import 'package:bckgrnd/ppln/ppln_controller.dart';
import 'package:bckgrnd/ppln/ppln_status.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:flutter/foundation.dart';

class LocalClient implements Client {
  final HashMap<String, StreamController<Map<String, dynamic>?>> _listeners =
      HashMap();

  StreamController<Map<String, dynamic>?> _listener(final String name) {
    if (!_listeners.containsKey(name)) {
      _listeners[name] = StreamController<Map<String, dynamic>?>();
    }
    return _listeners[name]!;
  }

  @override
  Future<void> initialize() async {
    var params = PplnParams();

    final pplnController = PplnController(
      params: params,
      onStatusChange: (final PplnStatus status) {
        debugPrint(
            '[LocalService] updateStatus: ${status.toPrettyJson().toString()}');
        invoke(
          'updateStatus',
          status.toJson(),
        );
      },
    );

    on('startRecording').listen((final event) async {
      debugPrint('[LocalService] startRecording');
      await pplnController.start();
    });

    on('stopRecording').listen((final event) async {
      debugPrint('[LocalService] stopRecording');
      await pplnController.stop();
    });

    on('updateParams').listen((final event) {
      debugPrint('[LocalService] updateParams');
      assert(event != null && event['params'] != null);
      params = PplnParams.fromJson(event!['params']);
      pplnController.params = params;
    });

    if (kDebugMode) {
      on('addAudioFile').listen((final event) async {
        debugPrint('[LocalService] addAudioFile');
        assert(event != null && event['filePath'] != null);
        final String filePath = event!['filePath'];
        await pplnController.addAudioFile(filePath);
      });
    }
  }

  @override
  Future<void> ensureServiceStarted(final PplnParams params) async {
    invoke('updateParams', {'params': params.toJson()});
  }

  @override
  void invoke(final String method, [final Map<String, dynamic>? arg]) =>
      _listener(method).add(arg);

  @override
  Stream<Map<String, dynamic>?> on(final String method) =>
      _listener(method).stream;
}
