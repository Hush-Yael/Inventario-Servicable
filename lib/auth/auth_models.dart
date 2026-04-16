import 'package:drift/drift.dart';
import 'package:servicable_stock/auth/auth_constants.dart';

class Users extends Table {
  late final id = integer().autoIncrement()();

  late final name = text().withLength(
    min: kNameMinLength,
    max: kNameMaxLength,
  )();

  late final username = text()
      .withLength(min: kUsernameMinLength, max: kUsernameMaxLength)
      .unique()();

  late final password = text().withLength(
    min: kPasswordMinLength,
    max: kPasswordMaxLength,
  )();

  late final salt = text()();

  late final role = intEnum<UserRole>()();

  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final lastLogin = dateTime().nullable()();
}
