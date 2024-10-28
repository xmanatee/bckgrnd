import 'dart:io';
import 'package:bckgrnd/background/background_client.dart';
import 'package:bckgrnd/background/local_client.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';

abstract class Client {
  static final Client instance =
      Platform.isMacOS ? LocalClient() : BackgroundClient();

  Future<void> initialize();

  Future<void> ensureServiceStarted(final PplnParams params);

  void invoke(final String method, [final Map<String, dynamic>? arg]);

  Stream<Map<String, dynamic>?> on(final String method);
}
