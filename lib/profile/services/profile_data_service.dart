import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/profile/profile_types.dart';

class ProfileDataService extends ServiceRepository {
  final int currentId;

  ProfileDataService(super.db, {required super.table, required this.currentId});

  Future<User> updateCurrentUser(UpdateDataInput input) async {
    final op =
        (db.update(db.users)
              ..whereSamePrimaryKey(UsersCompanion(id: Value(currentId))))
            .writeReturning(
              UsersCompanion(
                name: Value(input.name),
                username: Value(input.username),
              ),
            );

    final users = await stall(
      expectDBError(
        op,
        'No se pudieron actualizar los datos',
        onSqliteException: (error) =>
            error.extendedResultCode == ServiceRepository.uniqueConflict
            ? 'Ese nombre de usuario ya está en uso'
            : null,
      ),
      const .new(milliseconds: 250),
    );

    return users[0];
  }

  Future<bool> checkUserNameExists(String userName) async {
    return await (db.select(db.users)
              ..limit(1)
              ..where(
                (t) =>
                    t.username.equals(userName) & t.id.equals(currentId).not(),
              ))
            .getSingleOrNull() !=
        null;
  }
}
