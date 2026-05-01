import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

// Wrap widget with an invisible material card
class CardWrapper extends StatelessWidget {
  final TrinaGrid grid;

  const CardWrapper(this.grid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      borderOnForeground: false,
      color: Colors.transparent,
      child: grid,
    );
  }
}
