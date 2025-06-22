import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inner_state_bloc.dart';
import '../widgets/pulse_indicator.dart';
import '../../domain/entities/inner_state.dart';

class InnerStatePage extends StatelessWidget {
  const InnerStatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<InnerStateBloc, InnerStateBlocState>(
        builder: (context, state) {
          if (state is InnerStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InnerStateLoaded) {
            return GestureDetector(
              onPanEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 300) {
                  // Swipe right
                  context.read<InnerStateBloc>().add(SwipeRight());
                } else if (details.velocity.pixelsPerSecond.dx < -300) {
                  // Swipe left
                  context.read<InnerStateBloc>().add(SwipeLeft());
                }
              },
              child: Stack(
                children: [
                  // Background gradient
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _getBackgroundGradient(state.innerState),
                      ),
                    ),
                    child: const SizedBox.expand(),
                  ),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // State indicator
                        PulseIndicator(state: state.innerState),

                        const SizedBox(height: 60),

                        // State name
                        AnimatedOpacity(
                          opacity: state.showChaoticMessage ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _getStateName(state.innerState.type),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Instructions
                        AnimatedOpacity(
                          opacity: state.showChaoticMessage ? 0.0 : 0.6,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            '← Расфокус    Внимание →',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chaotic message
                  if (state.showChaoticMessage)
                    Center(
                      child: AnimatedOpacity(
                        opacity: state.showChaoticMessage ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.pause_circle_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Сделай паузу.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Подыши.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  List<Color> _getBackgroundGradient(InnerState state) {
    switch (state.type) {
      case StateType.focus:
        return [const Color(0xFF0F1419), const Color(0xFF1A237E)];
      case StateType.unfocus:
        return [const Color(0xFF1A0F1A), const Color(0xFF4A148C)];
      case StateType.chaotic:
        return [const Color(0xFF1A0F0F), const Color(0xFF8B0000)];
      case StateType.neutral:
        return [const Color(0xFF0F1A1A), const Color(0xFF004D40)];
    }
  }

  String _getStateName(StateType type) {
    switch (type) {
      case StateType.focus:
        return 'ВНИМАНИЕ';
      case StateType.unfocus:
        return 'РАСФОКУС';
      case StateType.chaotic:
        return 'ХАОС';
      case StateType.neutral:
        return 'НЕЙТРАЛЬНО';
    }
  }
}
