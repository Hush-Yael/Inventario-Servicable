import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/view_model/auth_state_mixin.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart';

mixin FormMixin on StateMixin {
  /// Callback for when a field is submitted through the keyboard
  Future<dynamic>? fieldSubmit(String value) =>
      isSubmitting.value ? null : submit();

  String get username => formKey.currentState?.fields['username']?.value ?? '';
  String get name => formKey.currentState?.fields['username']?.value ?? '';
  String get password => formKey.currentState?.fields['password']?.value ?? '';

  Future<void> submit() async {
    if (isSubmitting.value) {
      return;
    }

    clearAsyncErrors();

    if (formKey.currentState?.validate() != true) {
      return;
    }

    isSubmitting.value = true;

    final User? existingUser = await stall(
      service.getExistingUser(username),
      const Duration(milliseconds: 250),
    );

    final String? result = await stall(
      (isSignIn.value ? signIn(existingUser) : signUp(existingUser))
          .whenComplete(() => isSubmitting.value = false),
      const Duration(milliseconds: 250),
    );

    if (result == null && context.mounted) {
      displayInfoBar(
        context,
        duration: const Duration(seconds: 5),
        builder: (context, close) {
          return InfoBar(
            title: Text(isSignIn.value ? 'Bienvenido' : 'Cuenta creada'),
            severity: InfoBarSeverity.success,
          );
        },
      );
    }
  }

  Future<String?> signIn(User? existingUser) async {
    if (existingUser == null) {
      return invalidUsernameMsg.value = 'El usuario no existe';
    }

    final secretPassToCompare = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: base64Decode(existingUser.salt),
    );

    final String hashToCompare = base64Encode(
      await secretPassToCompare.extractBytes(),
    );

    final String storedHash = existingUser.password;

    if (hashToCompare != storedHash) {
      return invalidPasswordMsg.value = 'La contraseña es incorrecta';
    }

    await service.updateCurrentUserLastLogin(existingUser.id);

    authState.setUser(existingUser);

    return null;
  }

  Future<String?> signUp(User? existingUser) async {
    if (existingUser != null) {
      return invalidUsernameMsg.value = 'El usuario ya existe';
    }

    var random = Random.secure();

    var newSalt = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );

    final secretPass = await algorithm.deriveKeyFromPassword(
      password: password,
      nonce: newSalt,
    );

    final User newUser = await service.signupNewUser(
      name: name,
      username: username,
      password: base64Encode(await secretPass.extractBytes()),
      salt: base64Encode(newSalt),
    );

    authState.setUser(newUser);

    return null;
  }
}
