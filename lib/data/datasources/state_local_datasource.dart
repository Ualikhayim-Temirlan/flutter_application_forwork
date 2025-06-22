import 'package:shared_preferences/shared_preferences.dart';

abstract class StateLocalDataSource {
  Future<String?> getLastState();
  Future<void> saveState(String state);
}

class StateLocalDataSourceImpl implements StateLocalDataSource {
  static const String _stateKey = 'inner_state';

  @override
  Future<String?> getLastState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stateKey);
  }

  @override
  Future<void> saveState(String state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateKey, state);
  }
}
