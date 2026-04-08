import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/auth_vm.dart';

class FormBtns extends StatelessWidget {
  const FormBtns({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = AuthVm.provider.of(context);
    final isSignIn = vm.isSignIn;

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 8,
      children: [
        FilledButton(
          style: const ButtonStyle(padding: WidgetStatePropertyAll(.all(12))),
          onPressed: vm.isSubmitting.value ? null : vm.submit,
          child: vm.isSubmitting.value
              ? const SizedBox(
                  height: 20,
                  width: 20,

                  child: ProgressRing(strokeWidth: 3.5),
                )
              : Text(isSignIn.value ? 'Ingresar' : 'Crear'),
        ),

        HyperlinkButton(
          onPressed: vm.isSubmitting.value ? null : vm.toggleIsSignIn,
          style: const ButtonStyle(padding: WidgetStatePropertyAll(.all(12))),
          child: Text(isSignIn.value ? 'Crear cuenta' : 'Iniciar sesión'),
        ),
      ],
    );
  }
}
