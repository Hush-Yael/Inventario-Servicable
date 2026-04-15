import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/users/service/users_repository.dart';
import 'package:servicable_stock/users/users_types.dart';

class UsersService implements UsersRepository {
  final AppDatabase db;

  UsersService(this.db);

  @override
  Future<UsersList> fetchUsers() async {
    return await stall((db.select(db.users)).get());
  }

  @override
  Future<int> deleteUsers(List<int> ids) async {
    final int count = await stall(
      (db.delete(db.users)..where((u) => u.id.isIn(ids))).go(),
    );

    if (count > 0) {
      return count;
    } else {
      throw Exception('No se pudieron eliminar los usuarios');
    }
  }

  @override
  Future<int> changeUsersRole(UserRole role, List<int> ids) async {
    final int count = await stall(
      (db.update(
        db.users,
      )..where((u) => u.id.isIn(ids))).write(UsersCompanion(role: Value(role))),
    );

    if (count > 0) {
      return count;
    } else {
      throw Exception('No se pudieron cambiar los roles');
    }
  }
}
