import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// Universal hold detection overlay for kiosk exit
/// Detects long press anywhere on screen when on last category
class KioskExitHoldOverlay extends StatefulWidget {
  final Widget child;
  final bool isLastCategory;
  final VoidCallback onHoldComplete;

  const KioskExitHoldOverlay({
    super.key,
    required this.child,
    required this.isLastCategory,
    required this.onHoldComplete,
  });

  @override
  State<KioskExitHoldOverlay> createState() => _KioskExitHoldOverlayState();
}

class _KioskExitHoldOverlayState extends State<KioskExitHoldOverlay> {
  Timer? _holdTimer;
  bool _isHolding = false;
  double _holdProgress = 0.0;
  Offset? _holdPosition;

  void _startHoldTimer(Offset position) {
    if (!widget.isLastCategory) return;

    HapticFeedback.lightImpact();
    setState(() {
      _isHolding = true;
      _holdPosition = position;
    });

    const totalDuration = Duration(seconds: 3); // 3 seconds for easier testing
    const updateInterval = Duration(milliseconds: 50);
    int elapsed = 0;

    _holdTimer = Timer.periodic(updateInterval, (timer) {
      elapsed += updateInterval.inMilliseconds;
      final progress = elapsed / totalDuration.inMilliseconds;

      if (progress >= 1.0) {
        timer.cancel();
        _onHoldComplete();
      } else {
        if (mounted) {
          setState(() => _holdProgress = progress);
        }
      }
    });
  }

  void _cancelHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
    if (mounted) {
      setState(() {
        _isHolding = false;
        _holdProgress = 0.0;
        _holdPosition = null;
      });
    }
  }

  void _onHoldComplete() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
      _holdPosition = null;
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
    return Stack(
      children: [
        // Original content
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            if (widget.isLastCategory) {
              _startHoldTimer(event.position);
            }
          },
          onPointerUp: (_) => _cancelHoldTimer(),
          onPointerCancel: (_) => _cancelHoldTimer(),
          child: widget.child,
        ),

        // Hold progress indicator
        if (_isHolding && _holdPosition != null)
          Positioned(
            left: _holdPosition!.dx - 75,
            top: _holdPosition!.dy - 75,
            child: IgnorePointer(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular progress indicator
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _holdProgress,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    // Center content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hold',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${((1 - _holdProgress) * 3).ceil()}s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
