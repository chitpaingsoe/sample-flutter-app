// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

// A poor man's DI. This should be replaced by a proper solution once they
// are more stable.
library dependency_injector;

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:sample_app/shared_dependencies/todos_interactor.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';



import 'AuthenticationBloc.dart';

class Injector extends InheritedWidget {
  final TodosInteractor todosInteractor;
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  Injector({
    Key key,
    @required this.todosInteractor,
    @required this.userRepository,
    @required this.authenticationBloc,
    @required Widget child,
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Injector>();

  @override
  bool updateShouldNotify(Injector oldWidget) =>
      todosInteractor != oldWidget.todosInteractor ||
          authenticationBloc != oldWidget.authenticationBloc ||
      userRepository != oldWidget.userRepository;
}
