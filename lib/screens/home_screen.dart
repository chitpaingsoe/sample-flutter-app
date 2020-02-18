// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_app/shared_dependencies/keys.dart';
import 'package:sample_app/shared_dependencies/localization.dart';
import 'package:sample_app/shared_dependencies/models/visibility_filter.dart';
import 'package:sample_app/shared_dependencies/routes.dart';
import 'package:sample_app/shared_dependencies/stats_bloc.dart';
import 'package:sample_app/shared_dependencies/todos_list_bloc.dart';
import 'package:sample_app/shared_dependencies/user_bloc.dart';
import 'package:sample_app/shared_dependencies/user_entity.dart';
import 'package:sample_app/shared_dependencies/user_repository.dart';
import 'package:sample_app/widgets/extra_actions_button.dart';
import 'package:sample_app/widgets/filter_button.dart';
import 'package:sample_app/widgets/loading.dart';
import 'package:sample_app/widgets/stats_counter.dart';
import 'package:sample_app/widgets/todo_list.dart';
import 'package:sample_app/widgets/todos_bloc_provider.dart';

import '../AuthenticationBloc.dart';
import '../dependency_injection.dart';
import '../localization.dart';

enum AppTab { todos, stats }

class HomeScreen extends StatefulWidget {
  final UserRepository repository;
  final AuthenticationBloc bloc;

  HomeScreen({@required this.repository, this.bloc})
      : super(key: ArchSampleKeys.homeScreen);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  UserBloc usersBloc;
  StreamController<AppTab> tabController;

  @override
  void initState() {
    super.initState();

    usersBloc = UserBloc(widget.repository);
    tabController = StreamController<AppTab>();
  }

  signOut() async {
   widget.bloc.logout();
  }

  @override
  void dispose() {
    tabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosBloc = TodosBlocProvider.of(context);

    return StreamBuilder<UserEntity>(
      stream: usersBloc.load(),
      builder: (context, userSnapshot) {
        return StreamBuilder<AppTab>(
          initialData: AppTab.todos,
          stream: tabController.stream,
          builder: (context, activeTabSnapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(BlocLocalizations.of(context).appTitle),
                actions: _buildActions(
                  todosBloc,
                  activeTabSnapshot,
                  userSnapshot.hasData,
                ),
              ),
              body: userSnapshot.hasData
                  ? activeTabSnapshot.data == AppTab.todos
                      ? TodoList()
                      : StatsCounter(
                          buildBloc: () =>
                              StatsBloc(Injector.of(context).todosInteractor),
                        )
                  : LoadingSpinner(
                      key: ArchSampleKeys.todosLoading,
                    ),
              floatingActionButton: FloatingActionButton(
                key: ArchSampleKeys.addTodoFab,
                onPressed: () {
                  Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
                },
                child: Icon(Icons.add),
                tooltip: ArchSampleLocalizations.of(context).addTodo,
              ),
              bottomNavigationBar: BottomNavigationBar(
                key: ArchSampleKeys.tabs,
                currentIndex: AppTab.values.indexOf(activeTabSnapshot.data),
                onTap: (index) {
                  tabController.add(AppTab.values[index]);
                },
                items: AppTab.values.map((tab) {
                  return BottomNavigationBarItem(
                    icon: Icon(
                      tab == AppTab.todos ? Icons.list : Icons.show_chart,
                      key: tab == AppTab.stats
                          ? ArchSampleKeys.statsTab
                          : ArchSampleKeys.todoTab,
                    ),
                    title: Text(
                      tab == AppTab.stats
                          ? ArchSampleLocalizations.of(context).stats
                          : ArchSampleLocalizations.of(context).todos,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildActions(
    TodosListBloc todosBloc,
    AsyncSnapshot<AppTab> activeTabSnapshot,
    bool hasData,
  ) {
    if (!hasData) return [];

    return [
      RaisedButton(
        child: Text('Sign Out'),
        onPressed: signOut,
      ),
      StreamBuilder<VisibilityFilter>(
        stream: todosBloc.activeFilter,
        builder: (context, snapshot) {
          return FilterButton(
            isActive: activeTabSnapshot.data == AppTab.todos,
            activeFilter: snapshot.data ?? VisibilityFilter.all,
            onSelected: todosBloc.updateFilter,
          );
        },
      ),
      StreamBuilder<ExtraActionsButtonViewModel>(
        stream: Rx.combineLatest2(
          todosBloc.allComplete,
          todosBloc.hasCompletedTodos,
          (allComplete, hasCompletedTodos) {
            return ExtraActionsButtonViewModel(
              allComplete,
              hasCompletedTodos,
            );
          },
        ),
        builder: (context, snapshot) {
          return ExtraActionsButton(
            allComplete: snapshot.data?.allComplete ?? false,
            hasCompletedTodos: snapshot.data?.hasCompletedTodos ?? false,
            onSelected: (action) {
              if (action == ExtraAction.toggleAllComplete) {
                todosBloc.toggleAll();
              } else if (action == ExtraAction.clearCompleted) {
                todosBloc.clearCompleted();
              }
            },
          );
        },
      )
    ];
  }
}
