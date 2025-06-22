import '../entities/inner_state.dart';
import '../repositories/state_repository.dart';

class SaveState {
  final StateRepository repository;

  SaveState(this.repository);

  Future<void> call(InnerState state) async {
    await repository.saveState(state);
  }
}
