import 'package:bckgrnd/background/client.dart';
import 'package:bckgrnd/ui/bckgrnd_app.dart';
import 'package:bckgrnd/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Client.instance.initialize();
  await Storage.instance.initialize();
  runApp(const ProviderScope(child: BckgrndApp()));
}
