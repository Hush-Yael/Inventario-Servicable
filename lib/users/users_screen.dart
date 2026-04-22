import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/guard_widget.dart';
import 'package:servicable_stock/shared/widgets/table_title.dart';
import 'package:servicable_stock/users/users_constants.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';
import 'package:servicable_stock/users/widgets/change_role_btn.dart';
import 'package:servicable_stock/users/widgets/delete_btn.dart';
import 'package:servicable_stock/users/widgets/users_table.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(providers: [UsersVm.instance], child: _UsersScreen());
  }
}

class _UsersScreen extends HookWidget {
  const _UsersScreen();

  @override
  Widget build(BuildContext context) {
    final vm = UsersVm.instance.of(context);

    final UsersQuery query = useQuery(
      kUserTableQueryKey,
      (context) => vm.getUsers(),
    );

    return ScaffoldPage(
      header: PageHeader(
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            TableTitle(query: query, text: 'Lista de usuarios'),

            const Guard(
              role: .admin,
              child: Row(
                mainAxisAlignment: .end,
                spacing: 8,
                children: [DeleteBtn(), ChangeRoleBtn()],
              ),
            ),
          ],
        ),
      ),

      content: Padding(
        padding: const .only(bottom: 20, left: 20, right: 20),
        child: UsersTable(query),
      ),
    );
  }
}
