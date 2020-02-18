// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:key_value_store_web/key_value_store_web.dart';
import 'package:sample_app/shared_dependencies/localStorage/key_value_storage.dart';
import 'package:sample_app/shared_dependencies/localStorage/reactive_repository.dart';
import 'package:sample_app/shared_dependencies/localStorage/repository.dart';
import 'package:sample_app/shared_dependencies/todos_interactor.dart';
import 'package:sample_app/shared_dependencies/user_entity.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';
import 'package:sample_app/widgets/root_page.dart';

import 'AuthenticationBloc.dart';
import 'Helper/FileRepository.dart';


//Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//
//  runApp(SimpleBlocApp(
//    todosInteractor: TodosInteractor(
//      ReactiveLocalStorageRepository(
//        repository: LocalStorageRepository(
//          localStorage: KeyValueStorage(
//            'simple_bloc',
//            WebKeyValueStore(window.localStorage),
//          ),
//        ),
//      ),
//    ),
//    userRepository: AnonymousUserRepository(),
//  ));
//}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: RootPage(
        authenticationBloc: AuthenticationBloc(
          streamController: StreamController<AuthenticationState>(),
            repo: FileRepository(storage:  WebKeyValueStore(window.localStorage))
        ),
        todosInteractor: TodosInteractor(
          ReactiveLocalStorageRepository(
            repository: LocalStorageRepository(
              localStorage: KeyValueStorage(
                'simple_bloc',
                WebKeyValueStore(window.localStorage),
              ),
            ),
          ),
        ),
        userRepository: AnonymousUserRepository(),
      )));
}

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() async {
    return Future.value(UserEntity(id: 'anonymous'));
  }
}


