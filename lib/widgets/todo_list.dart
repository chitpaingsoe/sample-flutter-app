// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sample_app/screens/detail_screen.dart';
import 'package:sample_app/shared_dependencies/keys.dart';
import 'package:sample_app/shared_dependencies/localization.dart';
import 'package:sample_app/shared_dependencies/models/todo.dart';
import 'package:sample_app/shared_dependencies/todo_bloc.dart';
import 'package:sample_app/widgets/todo_item.dart';
import 'package:sample_app/widgets/todos_bloc_provider.dart';

import '../dependency_injection.dart';
import 'loading.dart';

class TodoList extends StatelessWidget {
  TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: TodosBlocProvider.of(context).visibleTodos,
      builder: (context, snapshot) => snapshot.hasData
          ? _buildList(snapshot.data)
          : LoadingSpinner(key: ArchSampleKeys.todosLoading),
    );
  }

  ListView _buildList(List<Todo> todos) {
    return ListView.builder(
      key: ArchSampleKeys.todoList,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return TodoItem(
          todo: todo,
          onDismissed: (direction) {
            _removeTodo(context, todo);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return DetailScreen(
                    todoId: todo.id,
                    initBloc: () =>
                        TodoBloc(Injector.of(context).todosInteractor),
                  );
                },
              ),
            ).then((todo) {
              if (todo is Todo) {
                _showUndoSnackbar(context, todo);
              }
            });
          },
          onCheckboxChanged: (complete) {
            TodosBlocProvider.of(context)
                .updateTodo(todo.copyWith(complete: !todo.complete));
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    TodosBlocProvider.of(context).deleteTodo(todo.id);

    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    final snackBar = SnackBar(
      key: ArchSampleKeys.snackbar,
      duration: Duration(seconds: 2),
      content: Text(
        ArchSampleLocalizations.of(context).todoDeleted(todo.task),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      action: SnackBarAction(
        key: ArchSampleKeys.snackbarAction(todo.id),
        label: ArchSampleLocalizations.of(context).undo,
        onPressed: () {
          TodosBlocProvider.of(context).addTodo(todo);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
