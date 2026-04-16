import 'package:drift/drift.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';

class AuthService extends ServiceRepository {
  const AuthService(super.db);

  /// Used to verify if a user already exists when signing in/up
  Future<User?> getExistingUser(String username) async {
    return await (db.select(db.users)
          ..where((u) => u.username.equals(username))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<User> signupNewUser({
    required String name,
    required String username,
    required String password,
    required String salt,
  }) async {
    final bool isFirst =
        await (db.select(db.users)..limit(1)).getSingleOrNull() == null;

    return db
        .into(db.users)
        .insertReturning(
          UsersCompanion.insert(
            role: isFirst ? UserRole.admin : UserRole.supervisor,
            name: name,
            username: username,
            password: password,
            salt: salt,
            lastLogin: Value(DateTime.now()),
          ),
        );
  }

  Future<int> updateCurrentUserLastLogin(int id) async {
    return await (db.update(db.users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(lastLogin: Value(DateTime.now())),
    );
  }
}
