import 'package:flutter/foundation.dart';

enum UserRole {
  admin,
  operator,
  supervisor;

  /// Returns the user role label
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.operator:
        return 'Operador';
      case UserRole.supervisor:
        return 'Supervisor';
    }
  }
}

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
