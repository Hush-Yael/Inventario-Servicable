import 'package:flutter/foundation.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:servicable_stock/core/utils/validators.dart';

enum UserRole {
  admin('Admin', 3),
  operator('Operador', 2),
  supervisor('Supervisor', 1);

  final String label;
  final int level;

  const UserRole(this.label, this.level);
}

enum AuthFormFields { name, username, password }

class AuthValidators {
  static final nameValidators = FormBuilderValidators.compose([
    Validators.required,
    FormBuilderValidators.match(
      RegExp(r'^[a-zA-Z\u00C0-\u017F\s]+$'),
      errorText: 'El nombre solo puede contener letras y espacios',
    ),
    Validators.minLength(kNameMinLength),
    Validators.maxLength(kNameMaxLength),
  ]);

  static final usernameValidators = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kUsernameMinLength),
    Validators.maxLength(kUsernameMaxLength),
    FormBuilderValidators.match(
      RegExp(r'^[a-zA-Z0-9_]+$'),
      errorText:
          'El nombre de usuario solo puede contener letras, números y pisos',
    ),
  ]);

  static final passwordValidators = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kPasswordMinLength),
    Validators.maxLength(kPasswordMaxLength),
  ]);
}

const kNameMinLength = 3;
const kNameMaxLength = 64;

const kUsernameMinLength = 3;
const kUsernameMaxLength = 64;

const kPasswordMinLength = kReleaseMode ? 6 : 3;
const kPasswordMaxLength = 128;
