import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';
import 'package:servicable_stock/users/widgets/table.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [UsersVm.instance],
      child: const UsersTable(),
    );
  }
}
