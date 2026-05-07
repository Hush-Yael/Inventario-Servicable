import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/auth_service.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/view_model/auth_form_mixin.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';

class AuthBaseVm extends FormWithAsyncValidation {
  final AuthService service;
  final BuildContext context;
  final AuthState authState;

  AuthBaseVm({
    required this.service,
    required this.context,
    required this.authState,
  });

  final algorithm = Argon2id(
    memory: 10 * 1000, // 10 MB
    parallelism: 2, //  two CPU cores.
    iterations: 1,
    hashLength: 32,
  );

  final isSignIn = Signal(true);

  void toggleIsSignIn() {
    if (isSubmitting.value) {
      return;
    }

    isSignIn.value = !isSignIn.value;
    formKey.currentState?.reset();
  }
}

class AuthVm extends AuthBaseVm with FormMixin {
  AuthVm({
    required super.service,
    required super.context,
    required super.authState,
  });

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);

    return AuthVm(
      service: AuthService(db, table: db.users),
      authState: AuthState.instance.of(ctx),
      context: ctx,
    );
  });
}
