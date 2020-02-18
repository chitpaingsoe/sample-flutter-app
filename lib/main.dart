// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:key_value_store_flutter/key_value_store_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sample_app/Helper/FileRepository.dart';
import 'package:sample_app/shared_dependencies/localStorage/key_value_storage.dart';
import 'package:sample_app/shared_dependencies/localStorage/reactive_repository.dart';
import 'package:sample_app/shared_dependencies/localStorage/repository.dart';
import 'package:sample_app/shared_dependencies/todos_interactor.dart';
import 'package:sample_app/shared_dependencies/user_entity.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';
import 'package:sample_app/widgets/root_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'AuthenticationBloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = LocalStorageRepository(
    localStorage: KeyValueStorage(
      'simple_bloc',
      FlutterKeyValueStore(await SharedPreferences.getInstance()),
    ),
  );

  runApp(MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: RootPage(
        authenticationBloc: AuthenticationBloc(
            streamController: StreamController<AuthenticationState>(),
            repo: FileRepository(storage: FlutterKeyValueStore(await SharedPreferences.getInstance()))
        ),
        todosInteractor: TodosInteractor(
          ReactiveLocalStorageRepository(
            repository: storage,
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
