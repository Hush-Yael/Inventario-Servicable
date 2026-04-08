import 'package:flutter/foundation.dart';

enum UserRole { admin, operator, supervisor }

const Map<UserRole, String> userRolesLabels = {
  UserRole.admin: 'Admin',
  UserRole.operator: 'Operador',
  UserRole.supervisor: 'Supervisor',
};

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
