import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';
import 'package:servicable_stock/profile/profile_types.dart';
import 'package:servicable_stock/shared/password_manager.dart';

class ProfilePassService extends ServiceRepository {
  final int currentId;
  final passwordManager = PasswordManager();

  ProfilePassService(super.db, {required super.table, required this.currentId});

  Future<bool> checkPassword({
    required String newPassword,
    required String hashedPassword,
    required String encodedSalt,
  }) async {
    return await passwordManager.compare(
      passwordToCompare: newPassword,
      hashedPassword: hashedPassword,
      encodedSalt: encodedSalt,
    );
  }

  Future<User> updateCurrentPassword(UpdatePassInput newPassword) async {
    final newSalt = passwordManager.generateSalt();

    final newSecretPass = await passwordManager.securePassword(
      passwordValue: newPassword,
      salt: newSalt,
    );

    final newHashedPassword = base64Encode(await newSecretPass.extractBytes());

    final op =
        (db.update(db.users)
              ..whereSamePrimaryKey(UsersCompanion(id: Value(currentId))))
            .writeReturning(
              UsersCompanion(
                password: Value(newHashedPassword),
                salt: Value(base64Encode(newSalt)),
              ),
            );

    final users = await expectDBError(
      op,
      'No se pudieron actualizar los datos',
    );

    return users[0];
  }
}
