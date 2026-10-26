import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// **Luxury Back Button**
///
/// Professional, minimal back button with smooth animations
/// Used across analytics pages to return to Sales Overview
class LuxuryBackButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? label;
  final bool isDarkMode;
  final bool showLabel;

  const LuxuryBackButton({
    super.key,
    required this.onPressed,
    this.label,
    this.isDarkMode = false,
    this.showLabel = true,
  });

  @override
  State<LuxuryBackButton> createState() => _LuxuryBackButtonState();
}

class _LuxuryBackButtonState extends State<LuxuryBackButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: -4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverChange(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChange(true),
      onExit: (_) => _onHoverChange(false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.translate(
                offset: Offset(_slideAnimation.value, 0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.showLabel ? 16 : 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? (widget.isDarkMode
                              ? Colors.white.withOpacity(0.08)
                              : AppColors.gray100)
                        : (widget.isDarkMode
                              ? Colors.white.withOpacity(0.04)
                              : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isHovered
                          ? (widget.isDarkMode
                                ? Colors.white.withOpacity(0.15)
                                : AppColors.gray300)
                          : (widget.isDarkMode
                                ? Colors.white.withOpacity(0.08)
                                : AppColors.gray300.withOpacity(0.5)),
                      width: 1,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color:
                                  (widget.isDarkMode
                                          ? Colors.black
                                          : AppColors.gray900)
                                      .withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back arrow icon
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: _isHovered
                            ? AppColors.blue
                            : (widget.isDarkMode
                                  ? Colors.white.withOpacity(0.85)
                                  : AppColors.gray700),
                      ),

                      // Label (optional)
                      if (widget.showLabel) ...[
                        const SizedBox(width: 8),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isHovered
                                ? AppColors.blue
                                : (widget.isDarkMode
                                      ? Colors.white.withOpacity(0.85)
                                      : AppColors.gray700),
                            letterSpacing: -0.2,
                          ),
                          child: Text(widget.label ?? 'Sales Overview'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// **Dashboard Slide-to-Access Widget**
///
/// Simple slide-up-and-hold interaction for dashboard access
/// Automatically returns to bottom when released
class DashboardSlideAccess extends StatefulWidget {
  final VoidCallback onUnlocked;
  final bool isDarkMode;

  const DashboardSlideAccess({
    super.key,
    required this.onUnlocked,
    this.isDarkMode = false,
  });

  @override
  State<DashboardSlideAccess> createState() => _DashboardSlideAccessState();
}

class _DashboardSlideAccessState extends State<DashboardSlideAccess>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0; // Current drag position (0.0 to 1.0)
  double _holdProgress = 0.0; // Hold progress (0.0 to 1.0)
  bool _isDragging = false;
  bool _showHoldText = false; // Control Hold text visibility
  Timer? _holdTimer;

  static const double _unlockThreshold = 0.85; // 85% up to start holding
  static const int _holdDurationMs = 1500; // 1.5 seconds to unlock
  static const double _trackHeight = 170.0;
  static const double _handleHeight = 56.0;

  late AnimationController _resetController;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _resetController.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _resetController.stop();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Update drag position based on delta
      final maxDragDistance = _trackHeight - _handleHeight - 16;
      _dragPosition = (_dragPosition - details.delta.dy / maxDragDistance)
          .clamp(0.0, 1.0);
    });

    // Start hold timer when reaching threshold
    if (_dragPosition >= _unlockThreshold && _holdTimer == null) {
      _startHoldTimer();
    } else if (_dragPosition < _unlockThreshold && _holdTimer != null) {
      _stopHoldTimer();
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _showHoldText = false; // Hide Hold text immediately when drag ends
    });
    _stopHoldTimer();
    _animateToBottom();
  }

  void _startHoldTimer() {
    _holdTimer?.cancel();
    setState(() {
      _holdProgress = 0.0;
      _showHoldText = true; // Show Hold text when holding starts
    });

    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _holdProgress += 50 / _holdDurationMs;
      });

      if (_holdProgress >= 1.0) {
        timer.cancel();
        _onUnlockSuccess();
      }
    });
  }

  void _stopHoldTimer() {
    _holdTimer?.cancel();
    _holdTimer = null;
    setState(() {
      _holdProgress = 0.0;
      _showHoldText = false; // Hide Hold text when timer stops
    });
  }

  void _animateToBottom() {
    _resetController.reset();
    _resetController.forward().then((_) {
      if (mounted) {
        setState(() {
          _dragPosition = 0.0;
        });
      }
    });
  }

  void _onUnlockSuccess() {
    _stopHoldTimer();
    // Trigger navigation
    widget.onUnlocked();
    // Reset after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animateToBottom();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAtThreshold = _dragPosition >= _unlockThreshold;
    final effectivePosition = _isDragging
        ? _dragPosition
        : _resetController.value * _dragPosition;

    return AnimatedBuilder(
      animation: _resetController,
      builder: (context, child) {
        return GestureDetector(
          onVerticalDragStart: _onVerticalDragStart,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Container(
            width: 72,
            height: _trackHeight,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: widget.isDarkMode
                    ? Colors.white.withOpacity(0.12)
                    : AppColors.gray300.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    widget.isDarkMode ? 0.3 : 0.1,
                  ),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Stack(
                children: [
                  // Hold progress fill (clipped to container shape)
                  if (isAtThreshold && _holdProgress > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: _trackHeight * _holdProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Color(0xFF34C759).withOpacity(0.3),
                              Color(0xFF34C759).withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Track indicators (dots)
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 32,
                          height: 2,
                          decoration: BoxDecoration(
                            color: widget.isDarkMode
                                ? Colors.white.withOpacity(0.15)
                                : AppColors.gray300.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Dashboard label (layer below blue circle - fades linearly as circle moves up)
                  Positioned(
                    bottom: 106,
                    left: -20,
                    right: -20,
                    child: AnimatedOpacity(
                      opacity: (1.0 - effectivePosition).clamp(0.0, 1.0),
                      duration: const Duration(milliseconds: 150),
                      child: Center(
                        child: Transform.rotate(
                          angle: -1.5708, // -90 degrees
                          child: Text(
                            'Dashboard',
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: widget.isDarkMode
                                  ? Colors.white.withOpacity(0.65)
                                  : AppColors.gray700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Sliding handle (top layer) with smooth transitions
                  Positioned(
                    bottom:
                        8 +
                        (effectivePosition *
                            (_trackHeight - _handleHeight - 16)),
                    left: 8,
                    right: 8,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: _handleHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isAtThreshold
                              ? [Color(0xFF34C759), Color(0xFF28A745)]
                              : [Color(0xFF007AFF), Color(0xFF0056B3)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isAtThreshold
                                        ? Color(0xFF34C759)
                                        : Color(0xFF007AFF))
                                    .withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Icon(
                          isAtThreshold
                              ? Icons.check_circle_outline
                              : Icons.home_rounded,
                          key: ValueKey(isAtThreshold),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),

                  // Hold instruction text (at bottom, below green circle)
                  if (_showHoldText)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Transform.rotate(
                          angle: -1.5708,
                          child: Text(
                            'Hold',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: widget.isDarkMode
                                  ? Colors.white.withOpacity(0.9)
                                  : Color(0xFF1A1A1A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
