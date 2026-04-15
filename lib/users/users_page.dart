import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';
import 'package:servicable_stock/users/widgets/table.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [UsersVm.instance],
      child: const UsersTable(),
    );
  }
}
