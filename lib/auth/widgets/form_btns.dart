import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/view_model/auth_vm.dart';
import 'package:servicable_stock/shared/widgets/submit_btn_ring.dart';

class FormBtns extends StatefulWidget {
  const FormBtns({super.key});

  @override
  State<FormBtns> createState() => _FormBtnsState();
}

class _FormBtnsState extends State<FormBtns> {
  @override
  Widget build(BuildContext context) {
    final vm = AuthVm.instance.of(context);
    final isSignIn = vm.isSignIn;

    return SignalBuilder(
      builder: (context, child) => Column(
        crossAxisAlignment: .stretch,
        spacing: 8,
        children: [
          FilledButton(
            style: const ButtonStyle(padding: WidgetStatePropertyAll(.all(12))),
            onPressed: vm.isSubmitting.value ? null : vm.submit,
            child: vm.isSubmitting.value
                ? const SubmitBtnRing()
                : Text(isSignIn.value ? 'Ingresar' : 'Crear'),
          ),

          HyperlinkButton(
            onPressed: vm.isSubmitting.value ? null : vm.toggleIsSignIn,
            style: const ButtonStyle(padding: WidgetStatePropertyAll(.all(12))),
            child: Text(isSignIn.value ? 'Crear cuenta' : 'Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
