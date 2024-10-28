import 'package:flutter/material.dart';
import 'package:bckgrnd/ui/home_page.dart';
import 'package:bckgrnd/ui/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BckgrndApp()));
}

class BckgrndApp extends ConsumerWidget {
  const BckgrndApp({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'bckgrnd',
      color: Theme.of(context).colorScheme.primary,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
