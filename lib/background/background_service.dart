import 'dart:ui';

import 'package:bckgrnd/ppln/ppln_controller.dart';
import 'package:bckgrnd/ppln/ppln_status.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:bckgrnd/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundService {
  static const notificationChannelId = 'background_service';
  static const notificationChannelName = 'Recording and processing';
  static const notificationChannelDescription =
      'Recording and processing in background';
  static const notificationTitle = 'bckgrnd';
  static const notificationContent = 'Processing in bckgrnd';

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(final ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    await Storage.instance.initialize();
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStartSafe(final ServiceInstance service) async {
    debugPrint('[BackgroundService] onStart');
    try {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();
      await Storage.instance.initialize();
      await onStart(service);
    } catch (e, stack) {
      debugPrint('Error in background service onStart: $e');
      debugPrint(stack.toString());
      await service.stopSelf();
    }
  }

  static Future<void> onStart(final ServiceInstance service) async {
    if (service is AndroidServiceInstance) {
      await service.setAsForegroundService();
      await service.setForegroundNotificationInfo(
        title: notificationTitle,
        content: notificationContent,
      );
    }

    var params = PplnParams();

    final pplnController = PplnController(
      params: params,
      onStatusChange: (final PplnStatus status) {
        debugPrint(
            '[BackgroundService] updateStatus: ${status.toPrettyJson().toString()}');
        service.invoke(
          'updateStatus',
          status.toJson(),
        );

        if (!status.isRecording && !status.isProcessing) {
          debugPrint('[BackgroundService] stopSelf');

          service.stopSelf();
        }
      },
    );

    service.on('startRecording').listen((final event) async {
      debugPrint('[BackgroundService] startRecording');
      try {
        await pplnController.start();
      } catch (e, stack) {
        debugPrint('[BackgroundService] Error in startRecording: $e');
        debugPrint(stack.toString());
      }
    });

    service.on('stopRecording').listen((final event) async {
      debugPrint('[BackgroundService] stopRecording');
      try {
        await pplnController.stop();
      } catch (e, stack) {
        debugPrint('[BackgroundService] Error in stopRecording: $e');
        debugPrint(stack.toString());
      }
    });

    service.on('updateParams').listen((final event) {
      debugPrint('[BackgroundService] updateParams');
      assert(event != null && event['params'] != null);
      params = PplnParams.fromJson(event!['params']);
      pplnController.params = params;
    });

    if (kDebugMode) {
      service.on('addAudioFile').listen((final event) async {
        debugPrint('[BackgroundService] addAudioFile');
        assert(event != null && event['filePath'] != null);
        final String filePath = event!['filePath'];
        await pplnController.addAudioFile(filePath);
      });
    }

    service.invoke('serviceStarted');
  }
}
