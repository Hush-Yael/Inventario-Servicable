// ignore_for_file: avoid_print

import 'package:drift/drift.dart' as drift;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/db/db.dart';

/// Used to recreate the database applying changes without migrations in dev mode
class WithResetBtn extends StatelessWidget {
  final Widget widget;

  const WithResetBtn({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,

        Positioned(
          bottom: 0,
          right: 0,
          child: Button(
            onPressed: () async {
              final db = AppDatabase.instance.of(context);
              final m = drift.Migrator(db);
              final tables = db.allTables;

              print('Resetting database...');

              // Disable foreign key constraints to avoid errors
              await db.customStatement('PRAGMA foreign_keys = OFF');

              await Future.wait(
                tables.map(
                  (table) => m
                      .deleteTable(table.actualTableName)
                      .then(
                        (value) => m
                            .createTable(table)
                            .then((value) => db.markTablesUpdated({table})),
                      ),
                ),
              );

              print('Database was reset successfully');

              await db.customStatement('PRAGMA foreign_keys = ON');
            },
            child: const WindowsIcon(FluentIcons.delete),
          ),
        ),
      ],
    );
  }
}
