import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/utils/guard_widget.dart';
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
          Title(query),

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

class Title extends StatelessWidget {
  const Title(this.query, {super.key});

  final UsersQuery query;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [const Text('Lista de usuarios'), getAdjacent(context)],
    );
  }

  Widget getAdjacent(BuildContext context) {
    // refresh indicator
    if (query.isRefetching) {
      return const SizedBox(
        width: 27,
        height: 27,
        child: ProgressRing(strokeWidth: 3),
      );
    }

    if (query.data == null) return const SizedBox.shrink();

    // total count
    return InfoBadge.informational(
      source: Text(
        NumberFormat.compact(
          locale: Localizations.localeOf(context).languageCode,
        ).format(query.data?.length),
      ),
    );
  }
}
