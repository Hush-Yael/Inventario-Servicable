import 'package:flutter/widgets.dart';

class TablePadding extends StatelessWidget {
  final Widget child;
  const TablePadding(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 20, left: 20, right: 20),
      child: child,
    );
  }
}
