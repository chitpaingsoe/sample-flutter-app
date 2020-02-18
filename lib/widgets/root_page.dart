import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_app/screens/add_edit_screen.dart';
import 'package:sample_app/shared_dependencies/localization.dart';
import 'package:sample_app/shared_dependencies/routes.dart';
import 'package:sample_app/shared_dependencies/theme.dart';
import 'package:sample_app/shared_dependencies/todos_interactor.dart';
import 'package:sample_app/shared_dependencies/todos_list_bloc.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';
import 'package:sample_app/widgets/todos_bloc_provider.dart';

import '../AuthenticationBloc.dart';
import '../AutheticationBlocProvider.dart';
import '../dependency_injection.dart';
import '../localization.dart';
import '../screens/LoginScreen.dart';
import '../screens/home_screen.dart';

class RootPage extends StatelessWidget {

  final TodosInteractor todosInteractor;
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  RootPage({
    Key key,
    this.todosInteractor,
    this.userRepository,
    this.authenticationBloc
  }) : super(key: key);

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationBlocProvider(
      bloc: authenticationBloc,
      child: StreamBuilder<AuthenticationState>(
          stream: authenticationBloc.stream,
          builder: (BuildContext context,
              AsyncSnapshot<AuthenticationState> snapshot) {
            //authenticationBloc.init();
            final state = snapshot.data;
            if (state == null) {
              authenticationBloc.init();
              return buildWaitingScreen();
            } else if (state.Authenticated) {
              return Injector(
                todosInteractor: todosInteractor,
                userRepository: userRepository,
                authenticationBloc: authenticationBloc,
                child: TodosBlocProvider(
                  bloc: TodosListBloc(todosInteractor),
                  child: MaterialApp(
                    onGenerateTitle: (context) =>
                    BlocLocalizations
                        .of(context)
                        .appTitle,
                    theme: ArchSampleTheme.theme,
                    localizationsDelegates: [
                      ArchSampleLocalizationsDelegate(),
                      InheritedWidgetLocalizationsDelegate(),
                    ],
                    routes: {
                      ArchSampleRoutes.home: (context) {
                        return HomeScreen(
                          repository: Injector
                              .of(context)
                              .userRepository,
                          bloc: authenticationBloc,
                        );
                      },
                      ArchSampleRoutes.addTodo: (context) {
                        return AddEditScreen(
                          addTodo: TodosBlocProvider
                              .of(context)
                              .addTodo,
                        );
                      },
                    },
                  ),
                ),
              );
            } else {
              return LoginScreen(
                bloc: authenticationBloc,
              );
            }
          }),
    );
  }
}
