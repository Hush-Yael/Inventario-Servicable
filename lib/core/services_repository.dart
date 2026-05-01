import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart';

/// All the services used in the app must have a db dependency
class ServiceRepository {
  final AppDatabase db;
  final TableInfo<Table, dynamic> table;

  const ServiceRepository(this.db, {required this.table});

  static const int uniqueConflict = 2067;
  static const int foreignConstraint = 1811;

  /// Update and delete operations must return at least 1 row to be considered successful
  Future<int> ensureMutated(Future<int> operation, String failedMsg) async {
    final int count = await operation;

    if (count > 0) {
      return count;
    } else {
      throw Exception(failedMsg);
    }
  }

  /// expect that, if db operation fails, an error that explains what went wrong should be thrown
  Future<T> expectDBError<T>(
    Future<T> operation,
    String defaultMsg, {
    String? Function(SqliteException error)? onSqliteException,
  }) async {
    try {
      return await operation;
    } catch (e) {
      if (e is DriftRemoteException) {
        final cause = e.remoteCause;

        if (cause is SqliteException && onSqliteException != null) {
          final msg = onSqliteException(cause);
          if (msg != null) throw msg;
        }
      }

      throw Exception(defaultMsg);
    }
  }

  Future<int> update<T extends UpdateCompanion>(
    int id,
    CompanionWithId constructorWithId,
    T companion, {
    required String defaultFailMsg,
    String? uniqueFailMsg,
  }) async {
    final op = (db.update(
      table,
    )..whereSamePrimaryKey(constructorWithId(id: Value(id)))).write(companion);

    return await expectDBError(
      ensureMutated(op, defaultFailMsg),
      defaultFailMsg,
      onSqliteException: (error) => error.extendedResultCode == uniqueConflict
          ? uniqueFailMsg ?? 'Se esperaba un valor único'
          : null,
    );
  }

  Future<int> delete<T extends CompanionWithId>(
    int id,
    T modelCompanion,
    String failedMsg,
  ) async {
    final op = stall(
      (db.delete(
        table,
      )..whereSamePrimaryKey(modelCompanion(id: Value(id)))).go(),
    );

    return await ensureMutated(op, failedMsg);
  }
}

typedef CompanionWithId = Function({required Value<int> id});
