import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/datasources/state_remote_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/state_local_datasource.dart';
import 'domain/usecases/get_last_state.dart';
import 'domain/usecases/save_state.dart';
import 'presentation/bloc/inner_state_bloc.dart';
import 'presentation/pages/inner_state_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inner State',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: BlocProvider(
        create: (context) {
          final dataSource = StateLocalDataSourceImpl();
          final repository = StateRepositoryImpl(dataSource);
          final getLastState = GetLastState(repository);
          final saveState = SaveState(repository);

          return InnerStateBloc(
            getLastState: getLastState,
            saveState: saveState,
          )..add(LoadInitialState());
        },
        child: const InnerStatePage(),
      ),
    );
  }
}
