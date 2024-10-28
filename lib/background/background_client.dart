import 'dart:async';

import 'dart:io';
import 'package:bckgrnd/background/background_service.dart';
import 'package:bckgrnd/background/client.dart';
import 'package:bckgrnd/permissions.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundClient extends Client {
  factory BackgroundClient() => _instance;
  BackgroundClient._internal();
  static final BackgroundClient _instance = BackgroundClient._internal();

  late final FlutterBackgroundService _service;

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      BackgroundService.notificationChannelId,
      BackgroundService.notificationChannelName,
      description: BackgroundService.notificationChannelDescription,
      importance: Importance.low,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Future<void> initialize() async {
    _service = FlutterBackgroundService();

    await _createNotificationChannel();

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: BackgroundService.onStartSafe,
        autoStart: false,
        isForegroundMode: true,
        initialNotificationTitle: BackgroundService.notificationTitle,
        initialNotificationContent: BackgroundService.notificationContent,
        notificationChannelId: BackgroundService.notificationChannelId,
        foregroundServiceNotificationId: 999,
        foregroundServiceTypes: [
          AndroidForegroundType.microphone,
        ],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: BackgroundService.onStartSafe,
        onBackground: BackgroundService.onIosBackground,
      ),
    );
  }

  @override
  Future<void> ensureServiceStarted(final PplnParams params) async {
    if (await _service.isRunning()) return;
    final completer = Completer<void>();
    final streamSubscription = on('serviceStarted').listen((final event) {
      completer.complete();
    });
    await Permissions.ensurePermissions();
    await _service.startService();
    await completer.future;
    await streamSubscription.cancel();

    assert(await _service.isRunning());
    invoke('updateParams', {'params': params.toJson()});
  }

  @override
  void invoke(final String method, [final Map<String, dynamic>? arg]) =>
      _service.invoke(method, arg);

  @override
  Stream<Map<String, dynamic>?> on(final String method) => _service.on(method);
}
