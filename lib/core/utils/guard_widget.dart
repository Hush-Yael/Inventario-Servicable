import 'package:flutter/material.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_controller.dart';

class Guard extends StatelessWidget {
  final Widget child;
  final UserRole role;
  const Guard({super.key, required this.child, required this.role});

  @override
  Widget build(BuildContext context) {
    if (AuthController.provider.of(context).user?.role == role) {
      return child;
    } else {
      return const SizedBox.shrink();
    }
  }
}
