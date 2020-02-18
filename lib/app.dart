//// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
//// Use of this source code is governed by the MIT license that can be found
//// in the LICENSE file.
//
//import 'package:flutter/material.dart';
//import 'package:simple_bloc_flutter_sample/dependency_injection.dart';
//import 'package:simple_bloc_flutter_sample/localization.dart';
//import 'package:simple_bloc_flutter_sample/screens/LoginScreen.dart';
//import 'package:simple_bloc_flutter_sample/screens/add_edit_screen.dart';
//import 'package:simple_bloc_flutter_sample/screens/home_screen.dart';


//import 'package:simple_bloc_flutter_sample/widgets/todos_bloc_provider.dart';
//import 'package:simple_blocs/simple_blocs.dart';
//import 'package:todos_app_core/todos_app_core.dart';
//import 'package:todos_repository_core/todos_repository_core.dart';
//import 'dart:async';
//
//class SimpleBlocApp extends StatelessWidget {
//  final TodosInteractor todosInteractor;
//  final UserRepository userRepository;
//
//
//   SimpleBlocApp({
//    Key key,
//    this.todosInteractor,
//    this.userRepository,
//  }) : super(key: key);
//
//  StreamController<AuthenticationState> streamController = StreamController<AuthenticationState>();
//
//
//  //authentication
//  Widget buildUi(BuildContext context, AuthenticationState s) {
//    if (s.authenticated) {
//      //return HomeScreen(repository: userRepository,);
//      return Injector(
//        todosInteractor: todosInteractor,
//        userRepository: userRepository,
//        child: TodosBlocProvider(
//          bloc: TodosListBloc(todosInteractor),
//          child: MaterialApp(
//            onGenerateTitle: (context) => BlocLocalizations.of(context).appTitle,
//            theme: ArchSampleTheme.theme,
//            localizationsDelegates: [
//              ArchSampleLocalizationsDelegate(),
//              InheritedWidgetLocalizationsDelegate(),
//            ],
//            routes: {
//              ArchSampleRoutes.home: (context) {
//                return HomeScreen(
//                  repository: Injector.of(context).userRepository,
//                  streamController: streamController,
//                );
//              },
//              ArchSampleRoutes.addTodo: (context) {
//                return AddEditScreen(
//                  addTodo: TodosBlocProvider.of(context).addTodo,
//                );
//              },
//            },
//          ),
//        ),
//      );
//    } else {
//      return LoginScreen(streamController);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new StreamBuilder<AuthenticationState>(
//        stream:  streamController.stream,
//        initialData: new AuthenticationState.initial(authenticated: Validator.checklogin()),
//        builder: (BuildContext context,
//            AsyncSnapshot<AuthenticationState> snapshot) {
//          final state = snapshot.data;
//          return buildUi(context, state);
//        });
//  }
//
//}
//
//
