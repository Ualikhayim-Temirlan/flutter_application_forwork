enum StateType { neutral, focus, unfocus, chaotic }

class InnerState {
  final StateType type;
  final double intensity;
  final double pulseSpeed;
  final double blurRadius;
  final double scale;

  const InnerState({
    required this.type,
    required this.intensity,
    required this.pulseSpeed,
    required this.blurRadius,
    required this.scale,
  });

  factory InnerState.neutral() => const InnerState(
    type: StateType.neutral,
    intensity: 0.5,
    pulseSpeed: 1.0,
    blurRadius: 0.0,
    scale: 1.0,
  );

  factory InnerState.focus() => const InnerState(
    type: StateType.focus,
    intensity: 1.0,
    pulseSpeed: 1.5,
    blurRadius: 0.0,
    scale: 1.2,
  );

  factory InnerState.unfocus() => const InnerState(
    type: StateType.unfocus,
    intensity: 0.3,
    pulseSpeed: 0.6,
    blurRadius: 8.0,
    scale: 0.8,
  );

  factory InnerState.chaotic() => const InnerState(
    type: StateType.chaotic,
    intensity: 0.8,
    pulseSpeed: 2.5,
    blurRadius: 4.0,
    scale: 1.1,
  );

  InnerState copyWith({
    StateType? type,
    double? intensity,
    double? pulseSpeed,
    double? blurRadius,
    double? scale,
  }) {
    return InnerState(
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      pulseSpeed: pulseSpeed ?? this.pulseSpeed,
      blurRadius: blurRadius ?? this.blurRadius,
      scale: scale ?? this.scale,
    );
  }
}
