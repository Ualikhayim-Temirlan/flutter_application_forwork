import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inner_state.dart';
import '../../domain/usecases/get_last_state.dart';
import '../../domain/usecases/save_state.dart';

// Events
abstract class InnerStateEvent {}

class LoadInitialState extends InnerStateEvent {}

class SwipeLeft extends InnerStateEvent {}

class SwipeRight extends InnerStateEvent {}

class ChaoticBehaviorDetected extends InnerStateEvent {}

class ResetFromChaotic extends InnerStateEvent {}

// States
abstract class InnerStateBlocState {}

class InnerStateLoading extends InnerStateBlocState {}

class InnerStateLoaded extends InnerStateBlocState {
  final InnerState innerState;
  final bool showChaoticMessage;

  InnerStateLoaded({required this.innerState, this.showChaoticMessage = false});

  InnerStateLoaded copyWith({
    InnerState? innerState,
    bool? showChaoticMessage,
  }) {
    return InnerStateLoaded(
      innerState: innerState ?? this.innerState,
      showChaoticMessage: showChaoticMessage ?? this.showChaoticMessage,
    );
  }
}

// Bloc
class InnerStateBloc extends Bloc<InnerStateEvent, InnerStateBlocState> {
  final GetLastState getLastState;
  final SaveState saveState;

  Timer? _chaoticTimer;
  int _recentSwipes = 0;
  DateTime _lastSwipeTime = DateTime.now();

  InnerStateBloc({required this.getLastState, required this.saveState})
    : super(InnerStateLoading()) {
    on<LoadInitialState>(_onLoadInitialState);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
    on<ChaoticBehaviorDetected>(_onChaoticBehaviorDetected);
    on<ResetFromChaotic>(_onResetFromChaotic);
  }

  Future<void> _onLoadInitialState(
    LoadInitialState event,
    Emitter<InnerStateBlocState> emit,
  ) async {
    try {
      final lastState = await getLastState();
      emit(InnerStateLoaded(innerState: lastState));
    } catch (e) {
      emit(InnerStateLoaded(innerState: InnerState.neutral()));
    }
  }

  Future<void> _onSwipeLeft(
    SwipeLeft event,
    Emitter<InnerStateBlocState> emit,
  ) async {
    if (state is InnerStateLoaded) {
      _checkChaoticBehavior();

      final newState = InnerState.unfocus();
      await saveState(newState);

      emit(
        (state as InnerStateLoaded).copyWith(
          innerState: newState,
          showChaoticMessage: false,
        ),
      );
    }
  }

  Future<void> _onSwipeRight(
    SwipeRight event,
    Emitter<InnerStateBlocState> emit,
  ) async {
    if (state is InnerStateLoaded) {
      _checkChaoticBehavior();

      final newState = InnerState.focus();
      await saveState(newState);

      emit(
        (state as InnerStateLoaded).copyWith(
          innerState: newState,
          showChaoticMessage: false,
        ),
      );
    }
  }

  Future<void> _onChaoticBehaviorDetected(
    ChaoticBehaviorDetected event,
    Emitter<InnerStateBlocState> emit,
  ) async {
    if (state is InnerStateLoaded) {
      final newState = InnerState.chaotic();
      await saveState(newState);

      emit(
        (state as InnerStateLoaded).copyWith(
          innerState: newState,
          showChaoticMessage: true,
        ),
      );

      // Автоматически сбрасываем через 3 секунды
      _chaoticTimer?.cancel();
      _chaoticTimer = Timer(const Duration(seconds: 3), () {
        add(ResetFromChaotic());
      });
    }
  }

  Future<void> _onResetFromChaotic(
    ResetFromChaotic event,
    Emitter<InnerStateBlocState> emit,
  ) async {
    if (state is InnerStateLoaded) {
      final newState = InnerState.neutral();
      await saveState(newState);

      emit(
        (state as InnerStateLoaded).copyWith(
          innerState: newState,
          showChaoticMessage: false,
        ),
      );
    }
  }

  void _checkChaoticBehavior() {
    final now = DateTime.now();
    if (now.difference(_lastSwipeTime).inMilliseconds < 500) {
      _recentSwipes++;
      if (_recentSwipes >= 5) {
        add(ChaoticBehaviorDetected());
        _recentSwipes = 0;
      }
    } else {
      _recentSwipes = 1;
    }
    _lastSwipeTime = now;
  }

  @override
  Future<void> close() {
    _chaoticTimer?.cancel();
    return super.close();
  }
}
