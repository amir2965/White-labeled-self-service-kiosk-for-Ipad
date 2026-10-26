import 'package:flutter/material.dart';
import 'dart:async';

/// Detects the secret exit gesture for kiosk mode
/// Usage: Wrap the scrollable content with this widget
class KioskExitDetector extends StatefulWidget {
  final Widget child;
  final bool isLastCategory;
  final bool isAtBottom;
  final VoidCallback onExitGestureDetected;

  const KioskExitDetector({
    super.key,
    required this.child,
    required this.isLastCategory,
    required this.isAtBottom,
    required this.onExitGestureDetected,
  });

  @override
  State<KioskExitDetector> createState() => _KioskExitDetectorState();
}

class _KioskExitDetectorState extends State<KioskExitDetector> {
  Timer? _holdTimer;
  bool _isHolding = false;
  double _holdProgress = 0.0;

  void _startHoldTimer() {
    if (!widget.isLastCategory || !widget.isAtBottom) return;

    setState(() => _isHolding = true);

    // Animate progress over 10 seconds
    const totalDuration = Duration(seconds: 10);
    const updateInterval = Duration(milliseconds: 100);
    int elapsed = 0;

    _holdTimer = Timer.periodic(updateInterval, (timer) {
      elapsed += updateInterval.inMilliseconds;
      final progress = elapsed / totalDuration.inMilliseconds;

      if (progress >= 1.0) {
        timer.cancel();
        _onHoldComplete();
      } else {
        setState(() => _holdProgress = progress);
      }
    });
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
  }

  void _onHoldComplete() {
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
    widget.onExitGestureDetected();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPressStart: (_) {
            if (widget.isLastCategory && widget.isAtBottom) {
              _startHoldTimer();
            }
          },
          onLongPressEnd: (_) => _cancelHoldTimer(),
          onLongPressCancel: () => _cancelHoldTimer(),
          child: widget.child,
        ),

        // Hold progress indicator
        if (_isHolding)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hold to exit kiosk mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 200,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _holdProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
