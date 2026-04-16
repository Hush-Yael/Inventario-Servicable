import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servicable_stock/auth/auth_service.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/auth/view_model/auth_state_mixin.dart';
import 'package:servicable_stock/auth/view_model/auth_form_mixin.dart';
import 'package:servicable_stock/core/db/db.dart';

class AuthBaseVm {
  final AuthService service;
  final BuildContext context;
  final GlobalKey<FormBuilderState> formKey;
  final AuthState authState;

  AuthBaseVm({
    required this.service,
    required this.formKey,
    required this.context,
    required this.authState,
  });

  final algorithm = Argon2id(
    memory: 10 * 1000, // 10 MB
    parallelism: 2, //  two CPU cores.
    iterations: 1,
    hashLength: 32,
  );
}

class AuthVm extends AuthBaseVm with StateMixin, FormMixin {
  AuthVm({
    required super.service,
    required super.formKey,
    required super.context,
    required super.authState,
  });

  static final instance = Provider.withArgument(
    (ctx, GlobalKey<FormBuilderState> formKey) => AuthVm(
      service: AuthService(AppDatabase.instance.of(ctx)),
      formKey: formKey,
      authState: AuthState.instance.of(ctx),
      context: ctx,
    ),
  );
}
