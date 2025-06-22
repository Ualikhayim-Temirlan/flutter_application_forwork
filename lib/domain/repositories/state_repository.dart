import '../entities/inner_state.dart';

abstract class StateRepository {
  Future<InnerState> getLastState();
  Future<void> saveState(InnerState state);
}
