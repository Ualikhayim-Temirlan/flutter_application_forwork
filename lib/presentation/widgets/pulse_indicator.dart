import 'dart:ui';
import 'package:flutter/material.dart';
import '../../domain/entities/inner_state.dart';

class PulseIndicator extends StatefulWidget {
  final InnerState state;

  const PulseIndicator({Key? key, required this.state}) : super(key: key);

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _transitionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(
        milliseconds: (1000 / widget.state.pulseSpeed).round(),
      ),
      vsync: this,
    )..repeat(reverse: true);

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.state.scale,
    ).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: widget.state.blurRadius,
    ).animate(
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
    );

    _transitionController.forward();
  }

  @override
  void didUpdateWidget(PulseIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state.pulseSpeed != widget.state.pulseSpeed) {
      _pulseController.duration = Duration(
        milliseconds: (1000 / widget.state.pulseSpeed).round(),
      );
    }

    if (oldWidget.state != widget.state) {
      _scaleAnimation = Tween<double>(
        begin: _scaleAnimation.value,
        end: widget.state.scale,
      ).animate(
        CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
      );

      _blurAnimation = Tween<double>(
        begin: _blurAnimation.value,
        end: widget.state.blurRadius,
      ).animate(
        CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
      );

      _transitionController.reset();
      _transitionController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _transitionController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: _blurAnimation.value,
              sigmaY: _blurAnimation.value,
            ),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: _getGradientColors(),
                  stops: const [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getPrimaryColor().withOpacity(0.3),
                    blurRadius: 30 * _pulseAnimation.value,
                    spreadRadius: 10 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getPrimaryColor().withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPrimaryColor() {
    switch (widget.state.type) {
      case StateType.focus:
        return Colors.blue;
      case StateType.unfocus:
        return Colors.purple;
      case StateType.chaotic:
        return Colors.red;
      case StateType.neutral:
        return Colors.teal;
    }
  }

  List<Color> _getGradientColors() {
    final primary = _getPrimaryColor();
    return [
      primary.withOpacity(widget.state.intensity),
      primary.withOpacity(widget.state.intensity * 0.5),
      primary.withOpacity(0.1),
    ];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _transitionController.dispose();
    super.dispose();
  }
}
