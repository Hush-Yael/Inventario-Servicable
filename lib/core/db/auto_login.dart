import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/db.dart';

void autoLogin(BuildContext context) {
  final db = AppDatabase.instance.of(context);
  final auth = AuthState.instance.of(context);

  (db.users.select()..where((t) => t.username.equals('admin')))
      .getSingleOrNull()
      .then((user) {
        if (user != null) auth.setUser(user);
      });
}
