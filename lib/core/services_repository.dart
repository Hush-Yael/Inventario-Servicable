import 'package:servicable_stock/core/db/db.dart';

/// All the services used in the app must have a db dependency
class ServiceRepository {
  final AppDatabase db;

  const ServiceRepository(this.db);
}
