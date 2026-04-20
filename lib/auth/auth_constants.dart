import 'package:flutter/foundation.dart';

enum UserRole {
  admin('Admin', 3),
  operator('Operador', 2),
  supervisor('Supervisor', 1);

  final String label;
  final int level;

  const UserRole(this.label, this.level);
}

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
