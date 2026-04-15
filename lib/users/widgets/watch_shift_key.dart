import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class WatchShiftKey extends StatefulWidget {
  final Widget child;
  final void Function(bool pressed) onShiftPressed;

  const WatchShiftKey({
    super.key,
    required this.child,
    required this.onShiftPressed,
  });

  @override
  State<WatchShiftKey> createState() => _WatchShiftKeyState();
}

class _WatchShiftKeyState extends State<WatchShiftKey> {
  bool _handler(KeyEvent event) {
    final key = event.logicalKey;

    if (event is! KeyDownEvent) {
      widget.onShiftPressed(false);
    } else {
      if (key == LogicalKeyboardKey.shiftLeft ||
          key == LogicalKeyboardKey.shiftRight) {
        widget.onShiftPressed(true);
      } else {
        widget.onShiftPressed(false);
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_handler);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_handler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
