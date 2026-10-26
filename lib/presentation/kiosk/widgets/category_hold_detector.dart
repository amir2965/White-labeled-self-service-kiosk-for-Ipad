import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Widget that detects a 10-second hold on category tabs
class CategoryHoldDetector extends StatefulWidget {
  final Widget child;
  final bool isLastCategory;
  final VoidCallback onHoldComplete;

  const CategoryHoldDetector({
    super.key,
    required this.child,
    required this.isLastCategory,
    required this.onHoldComplete,
  });

  @override
  State<CategoryHoldDetector> createState() => _CategoryHoldDetectorState();
}

class _CategoryHoldDetectorState extends State<CategoryHoldDetector> {
  Timer? _holdTimer;
  bool _isHolding = false;
  double _holdProgress = 0.0;

  void _startHoldTimer() {
    if (!widget.isLastCategory) return;

    HapticFeedback.lightImpact();
    setState(() => _isHolding = true);

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
    HapticFeedback.mediumImpact();
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
    widget.onHoldComplete();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        if (widget.isLastCategory) {
          _startHoldTimer();
        }
      },
      onLongPressEnd: (_) => _cancelHoldTimer(),
      onLongPressCancel: () => _cancelHoldTimer(),
      child: Stack(
        children: [
          widget.child,
          // Progress indicator overlay
          if (_isHolding)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Progress bar background
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _holdProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: _holdProgress >= 0.98
                                    ? Radius.circular(12)
                                    : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
