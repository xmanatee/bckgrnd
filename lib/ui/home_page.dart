import 'dart:io';

import 'package:bckgrnd/background/client.dart';
import 'package:bckgrnd/ppln/ppln_status.dart';
import 'package:bckgrnd/ppln/ppln_params.dart';
import 'package:bckgrnd/ppln/ppln_segment_status.dart';
import 'package:bckgrnd/ui/ppln_segment_view.dart';
import 'package:bckgrnd/ui/record_button.dart';
import 'package:bckgrnd/ui/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _client = Client.instance;
  PplnParams _params = PplnParams();

  bool _isRecording = false;
  String? _errorMessage;
  List<PplnSegmentStatus> _segments = [];

  @override
  void initState() {
    super.initState();

    _client.on('updateStatus').listen((final event) {
      if (event != null) {
        final statusJson = Map<String, dynamic>.from(event as Map);
        final status = PplnStatus.fromJson(statusJson);
        setState(() {
          _isRecording = status.isRecording;
          _errorMessage = status.error;
          _segments = status.segments;
        });
      }
    });
  }

  void _onParamsChanged(final PplnParams newParams) {
    setState(() {
      _params = newParams;
    });

    _client.invoke('updateParams', {'params': _params.toJson()});
  }

  Future<void> _jfkTestSafe() async {
    try {
      await _jfkTest();
    } catch (e) {
      setState(() {
        _errorMessage = 'JFK Test failed: $e';
      });
    }
  }

  Future<void> _jfkTest() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final documentBytes = await rootBundle.load('assets/jfk.wav');

    final jfkPath = '${documentDirectory.path}/jfk.wav';
    await File(jfkPath).writeAsBytes(documentBytes.buffer.asUint8List());

    await _client.ensureServiceStarted(_params);
    _client.invoke('addAudioFile', {'filePath': jfkPath});
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bckgrnd'),
        centerTitle: true,
        actions: [
          const Tooltip(
            message: 'Local Processing & Privacy',
            child: Icon(Icons.lock),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final context) => SettingsPage(
                    params: _params,
                    onParamsChanged: _onParamsChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: RecordButton(
                isRecording: _isRecording,
                onStart: () async {
                  await _client.ensureServiceStarted(_params);
                  _client.invoke('startRecording');
                },
                onStop: () {
                  _client.invoke('stopRecording');
                },
              ),
            ),
            const SizedBox(height: 10),
            if (kDebugMode) // Show only in debug mode
              Center(
                child: IconButton(
                  iconSize: 48, // Adjust size as needed
                  icon: const Icon(
                    Icons.play_arrow, // Choose an appropriate icon
                  ),
                  onPressed: _jfkTestSafe,
                  tooltip: 'JFK Test',
                ),
              ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Center(
                child: Chip(
                  label: Text(
                    'Error: $_errorMessage',
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            Expanded(
              child: _segments.isNotEmpty
                  ? ListView.builder(
                      itemCount: _segments.length,
                      itemBuilder: (final context, final index) {
                        return PplnSegmentView(
                          segmentStatus:
                              _segments[_segments.length - 1 - index],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Start recording to see segments',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
