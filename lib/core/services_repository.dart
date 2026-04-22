import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:servicable_stock/core/db/db.dart';

/// All the services used in the app must have a db dependency
class ServiceRepository {
  final AppDatabase db;

  const ServiceRepository(this.db);

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
}
