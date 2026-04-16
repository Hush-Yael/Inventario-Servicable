import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/view_model/auth_vm.dart';

mixin StateMixin on AuthBaseVm {
  final isSignIn = Signal(true);
  final invalidUsernameMsg = Signal<String?>(null);
  final invalidPasswordMsg = Signal<String?>(null);
  final isSubmitting = Signal(false);

  void toggleIsSignIn() {
    if (isSubmitting.value) {
      return;
    }

    isSignIn.value = !isSignIn.value;
    formKey.currentState?.reset();
    clearAsyncErrors();
  }

  void clearAsyncErrors() {
    invalidUsernameMsg.value = null;
    invalidPasswordMsg.value = null;
  }
}
