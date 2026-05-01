import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaFilterColumnWidgetDelegate noFilterField() => .builder(
  filterWidgetBuilder:
      (focusNode, controller, enabled, handleOnChanged, stateManager) =>
          SizedBox.shrink(),
);
