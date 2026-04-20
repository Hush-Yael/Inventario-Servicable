import 'package:servicable_stock/core/db/db.dart';

/// All the services used in the app must have a db dependency
class ServiceRepository {
  final AppDatabase db;

  const ServiceRepository(this.db);

  /// Update and delete operations must return at least 1 row to be considered successful
  Future<int> ensureMutated(Future<int> operation, String failedMsg) async {
    final int count = await operation;

    if (count > 0) {
      return count;
    } else {
      throw Exception(failedMsg);
    }
  }
}
