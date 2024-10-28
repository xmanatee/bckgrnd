import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:bckgrnd/ppln/transcribe/whisper_params.dart';
import 'package:bckgrnd/ppln/record/record_params.dart';
import 'package:flutter/material.dart';
import 'package:bckgrnd/ui/settings/whisper_params_view.dart';
import 'package:bckgrnd/ui/settings/record_params_view.dart';
import 'package:bckgrnd/ui/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({
    super.key,
    required this.params,
    required this.onParamsChanged,
  });

  final PplnParams params;
  final ValueChanged<PplnParams> onParamsChanged;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late PplnParams _params = widget.params;

  @override
  void initState() {
    super.initState();
    _params = widget.params; // Initialize in initState
  }

  void _onWhisperParamsChanged(final WhisperParams newWhisperParams) {
    setState(() {
      _params = _params.copyWith(whisperParams: newWhisperParams);
    });
    widget.onParamsChanged(_params);
  }

  void _onRecordParamsChanged(final RecordParams newRecordParams) {
    setState(() {
      _params = _params.copyWith(recordParams: newRecordParams);
    });
    widget.onParamsChanged(_params);
  }

  @override
  Widget build(final BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: Text(
                  'Privacy & Security',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'All data is processed locally on your device.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: isDarkMode,
                onChanged: (final bool value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                secondary: const Icon(Icons.dark_mode),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ExpansionTile(
                title: Text(
                  'Whisper Params',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: [
                  WhisperParamsView(
                    params: _params.whisperParams,
                    onChanged: _onWhisperParamsChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ExpansionTile(
                title: Text(
                  'Record Params',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: [
                  RecordParamsView(
                    params: _params.recordParams,
                    onChanged: _onRecordParamsChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
