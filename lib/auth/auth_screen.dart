import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/widgets/form_btns.dart';
import 'package:servicable_stock/auth/widgets/form_fields.dart';
import 'package:servicable_stock/core/theme.dart';
import 'package:servicable_stock/auth/auth_vm.dart';
import 'package:servicable_stock/auth/widgets/theme_selector.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxHeight: double.infinity,
                  ),
                  child: Center(child: Form()),
                ),
              ),
              const SignInUpThemeSelector(),
            ],
          );
        },
      ),
    );
  }
}

class Form extends StatelessWidget {
  Form({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [AuthVm.provider(_formKey)],
      child: FormBuilder(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const .all(20),
            child: Column(
              mainAxisAlignment: .center,
              spacing: 30,
              children: [
                Image.asset('assets/logo.png', width: 300),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    minHeight: 350,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: .circular(10),

                      border: .all(
                        color: context.theme.resources.cardStrokeColorDefault,
                      ),
                    ),
                    padding: const .symmetric(horizontal: 20, vertical: 15),
                    child: SignalBuilder(
                      builder: (context, child) {
                        final vm = AuthVm.provider.of(context);
                        final isSignIn = vm.isSignIn;

                        return Column(
                          crossAxisAlignment: .stretch,
                          mainAxisAlignment: .spaceBetween,
                          spacing: 20,
                          children: [
                            Text(
                              isSignIn.value
                                  ? 'Ingresar al sistema'
                                  : 'Crear cuenta',
                              style: context.theme.typography.title,
                              textAlign: .center,
                            ),

                            FormFields(),

                            FormBtns(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
