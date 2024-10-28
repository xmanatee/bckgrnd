import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    super.key,
    required this.isRecording,
    required this.onStart,
    required this.onStop,
  });

  final bool isRecording;
  final VoidCallback onStart;
  final VoidCallback onStop;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isRecording) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant final RecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isRecording && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: widget.isRecording ? widget.onStop : widget.onStart,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (final context, final child) {
          return Transform.scale(
            scale: widget.isRecording ? _animation.value : 1.0,
            child: child,
          );
        },
        child: Icon(
          widget.isRecording ? Icons.stop_circle : Icons.mic_rounded,
          size: 64,
        ),
      ),
    );
  }
}
