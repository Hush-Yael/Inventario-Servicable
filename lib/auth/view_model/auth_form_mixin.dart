import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/view_model/auth_vm.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart';

typedef Field = FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>;
mixin FormMixin on AuthBaseVm {
  Field get username =>
      formKey.currentState!.fields[AuthFormFields.username.name]!;
  Field get name => formKey.currentState!.fields[AuthFormFields.name.name]!;
  Field get password =>
      formKey.currentState!.fields[AuthFormFields.password.name]!;

  Future submit([dynamic fieldValue]) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final User? existingUser = await stall(
      service.getExistingUser(username.value),
      const Duration(milliseconds: 250),
    );

    final bool fine = await stall(
      (isSignIn.value ? signIn(existingUser) : signUp(existingUser))
          .whenComplete(() => isSubmitting.value = false),
      const .new(milliseconds: 250),
    );

    if (fine && context.mounted) {
      showMsg(
        context: context,
        message: isSignIn.value ? 'Bienvenido' : 'Cuenta creada',
        severity: .success,
      );
    }
  }

  Future<bool> signIn(User? existingUser) async {
    if (existingUser == null) {
      username.invalidate('El usuario no existe');
      return false;
    }

    final secretPassToCompare = await algorithm.deriveKeyFromPassword(
      password: password.value,
      nonce: base64Decode(existingUser.salt),
    );

    final String hashToCompare = base64Encode(
      await secretPassToCompare.extractBytes(),
    );

    final String storedHash = existingUser.password;

    if (hashToCompare != storedHash) {
      if (context.mounted) {
        showMsg(
          context: context,
          message: 'La contraseña es incorrecta',
          severity: .error,
          alignment: .bottomCenter,
        );
      }

      return false;
    }

    await service.updateCurrentUserLastLogin(existingUser.id);

    authState.setUser(existingUser);

    return true;
  }

  Future<bool> signUp(User? existingUser) async {
    if (existingUser != null) {
      username.invalidate('El usuario ya existe');
      return false;
    }

    final random = Random.secure();

    final newSalt = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );

    final secretPass = await algorithm.deriveKeyFromPassword(
      password: password.value,
      nonce: newSalt,
    );

    final User newUser = await service.signupNewUser(
      name: name.value,
      username: username.value,
      password: base64Encode(await secretPass.extractBytes()),
      salt: base64Encode(newSalt),
    );

    authState.setUser(newUser);

    return true;
  }
}
