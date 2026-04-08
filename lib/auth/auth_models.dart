import 'package:drift/drift.dart';
import 'package:servicable_stock/auth/auth_constants.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name =>
      text().withLength(min: kNameMinLength, max: kNameMaxLength)();

  TextColumn get username => text()
      .withLength(min: kUsernameMinLength, max: kUsernameMaxLength)
      .unique()();

  TextColumn get password =>
      text().withLength(min: kPasswordMinLength, max: kPasswordMaxLength)();

  TextColumn get salt => text()();

  IntColumn get role => intEnum<UserRole>()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get lastLogin => dateTime().nullable()();
}
