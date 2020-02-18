// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:sample_app/shared_dependencies/user_entity.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';



class UserBloc {
  final UserRepository _repository;

  // Outputs
  Stream<UserEntity> load() =>
      _repository.login().asStream().asBroadcastStream();

  UserBloc(UserRepository repository) : this._repository = repository;
}
