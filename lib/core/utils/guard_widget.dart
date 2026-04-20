import 'package:flutter/material.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';

class Guard extends StatelessWidget {
  final Widget child;
  final UserRole role;
  const Guard({super.key, required this.child, required this.role});

  @override
  Widget build(BuildContext context) {
    final currentRoleLevel =
        (AuthState.instance.of(context).user?.role ?? UserRole.supervisor)
            .level;

    final needRoleLevel = role.level;

    if (currentRoleLevel <= needRoleLevel) return const SizedBox.shrink();

    return child;
  }
}
