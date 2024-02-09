import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// An extension on [Duration] to calculate the FPS.
extension FPS on Duration {
  double get fps => (1000 / inMilliseconds);
}

/// A widget that shows the current FPS.
class FPSMonitor extends StatefulWidget {
  /// Whether to show the [ShowFPS].
  /// ```dart
  /// ShowFPS(
  ///   visible: !kReleaseMode,
  ///   child: MyHomePage(),
  /// )
  /// ```
  final bool visible;

  const FPSMonitor({
    Key? key,
    this.visible = true,
  }) : super(key: key);

  @override
  FPSMonitorState createState() => FPSMonitorState();
}

class FPSMonitorState extends State<FPSMonitor> {
  Duration? _previous;
  List<Duration> _timings = [];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(_update);
    super.initState();
  }

  @override
  void dispose() {
    _previous = null;
    _timings.clear();
    super.dispose();
  }

  void _update(Duration duration) {
    if (!mounted || !widget.visible) {
      return;
    }

    setState(() {
      if (_previous != null) {
        _timings.add(duration - _previous!);
      }

      _previous = duration;
    });

    SchedulerBinding.instance.addPostFrameCallback(_update);
  }

  @override
  void didUpdateWidget(covariant FPSMonitor oldWidget) {
    if (oldWidget.visible && !widget.visible) {
      _previous = null;
    }

    if (!oldWidget.visible && widget.visible) {
      SchedulerBinding.instance.addPostFrameCallback(_update);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    final _labelSmall = _textTheme.labelSmall!.copyWith(
      fontSize: 8,
      color: Colors.white,
    );

    final _labelLarge = _textTheme.labelLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'FPS',
          style: _labelSmall,
        ),
        (widget.visible && _timings.isNotEmpty)
            ? Text(
                _timings.last.fps.toStringAsFixed(0),
                style: _labelLarge,
              )
            : Text(
                '0',
                style: _labelLarge,
              ),
      ],
    );
  }
}
