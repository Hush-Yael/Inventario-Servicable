import 'package:flutter/foundation.dart';

enum UserRole {
  admin('Admin'),
  operator('Operador'),
  supervisor('Supervisor');

  final String label;

  const UserRole(this.label);
}

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
