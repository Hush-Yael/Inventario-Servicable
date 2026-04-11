import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_models.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'db.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: kReleaseMode
          ? const DriftNativeOptions(
              databaseDirectory: getApplicationSupportDirectory,
            )
          : DriftNativeOptions(
              databasePath: () async {
                final directory = Directory.current.path;

                return p.join(directory, 'lib', 'core', 'db', 'dev.db');
              },
            ),
    );
  }

  static final provider = Provider((context) => AppDatabase());
}
