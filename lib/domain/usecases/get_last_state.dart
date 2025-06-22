import '../entities/inner_state.dart';
import '../repositories/state_repository.dart';

class GetLastState {
  final StateRepository repository;

  GetLastState(this.repository);

  Future<InnerState> call() async {
    return await repository.getLastState();
  }
}
