import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/utils/guard_widget.dart';
import 'package:servicable_stock/shared/widgets/table_title.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/widgets/change_role_btn.dart';
import 'package:servicable_stock/users/widgets/delete_btn.dart';

class Header extends HookWidget {
  final UsersQuery query;

  const Header(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          TableTitle(query: query, text: 'Lista de usuarios'),

          const Guard(
            role: UserRole.admin,
            child: Row(
              mainAxisAlignment: .end,
              spacing: 8,
              children: [DeleteBtn(), ChangeRoleBtn()],
            ),
          ),
        ],
      ),
    );
  }
}
