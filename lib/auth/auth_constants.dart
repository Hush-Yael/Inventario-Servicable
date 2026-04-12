import 'package:flutter/foundation.dart';

enum UserRole {
  admin(label: 'Admin'),
  operator(label: 'Operador'),
  supervisor(label: 'Supervisor');

  final String label;

  const UserRole({required this.label});
}

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
