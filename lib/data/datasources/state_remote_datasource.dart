import '../../domain/entities/inner_state.dart';
import '../../domain/repositories/state_repository.dart';
import '../datasources/state_local_datasource.dart';

class StateRepositoryImpl implements StateRepository {
  final StateLocalDataSource localDataSource;

  StateRepositoryImpl(this.localDataSource);

  @override
  Future<InnerState> getLastState() async {
    final stateString = await localDataSource.getLastState();
    if (stateString == null) return InnerState.neutral();

    switch (stateString) {
      case 'focus':
        return InnerState.focus();
      case 'unfocus':
        return InnerState.unfocus();
      case 'chaotic':
        return InnerState.chaotic();
      default:
        return InnerState.neutral();
    }
  }

  @override
  Future<void> saveState(InnerState state) async {
    await localDataSource.saveState(state.type.name);
  }
}
