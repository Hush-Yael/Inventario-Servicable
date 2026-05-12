import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/profile/view_models/profile_data_vm.dart';
import 'package:servicable_stock/profile/view_models/profile_pass_vm.dart';
import 'package:servicable_stock/profile/widgets/profile_change_pass.dart';
import 'package:servicable_stock/profile/widgets/profile_data.dart';
import 'package:servicable_stock/shared/widgets/table_padding.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Column(
        children: [
          const PageHeader(padding: 12, title: Text('Datos de la cuenta')),
          const Divider(),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const .symmetric(vertical: 18.0),
          child: TablePadding(
            Row(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: 50,
              children: [
                Expanded(
                  child: ProviderScope(
                    providers: [ProfileDataVm.instance],
                    child: const Data(),
                  ),
                ),

                const Divider(direction: Axis.vertical),

                Expanded(
                  child: ProviderScope(
                    providers: [ProfilePassVm.instance],
                    child: const ChangePass(),
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
