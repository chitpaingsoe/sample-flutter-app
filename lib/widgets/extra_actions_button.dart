// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sample_app/shared_dependencies/keys.dart';
import 'package:sample_app/shared_dependencies/localization.dart';


class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected<ExtraAction> onSelected;
  final bool allComplete;
  final bool hasCompletedTodos;

  ExtraActionsButton({
    this.onSelected,
    this.allComplete = false,
    this.hasCompletedTodos = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExtraAction>(
      key: ArchSampleKeys.extraActionsButton,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<ExtraAction>>[
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.toggleAll,
            value: ExtraAction.toggleAllComplete,
            child: Text(
              allComplete
                  ? ArchSampleLocalizations.of(context).markAllIncomplete
                  : ArchSampleLocalizations.of(context).markAllComplete,
            ),
          ),
          PopupMenuItem<ExtraAction>(
            key: ArchSampleKeys.clearCompleted,
            value: ExtraAction.clearCompleted,
            child: Text(
              ArchSampleLocalizations.of(context).clearCompleted,
            ),
          ),
        ];
      },
    );
  }
}

class ExtraActionsButtonViewModel {
  final bool allComplete;
  final bool hasCompletedTodos;

  ExtraActionsButtonViewModel(this.allComplete, this.hasCompletedTodos);
}

enum ExtraAction { toggleAllComplete, clearCompleted }
