import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_models.dart';
import 'package:path/path.dart' as p;
import 'package:servicable_stock/core/db/seed.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'dart:io';
import 'package:servicable_stock/stock/units/units_models.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Users, Products, Categories, Units])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        // Enable foreign keys immediately upon opening the database
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

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

  static final instance = Provider((context) => AppDatabase());
}

/// Mixin to add [createdAt] and [updatedAt] columns
mixin TimeStampedRecord on Table {
  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}
