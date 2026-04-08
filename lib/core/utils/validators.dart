import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Validators {
  static final FormFieldValidator<String> required =
      FormBuilderValidators.required(errorText: 'Este campo es requerido');

  static FormFieldValidator<String> minLength(int length) =>
      FormBuilderValidators.minLength(
        length,
        errorText: 'Se requieren al menos $length caracteres',
      );

  static FormFieldValidator<String> maxLength(int length) =>
      FormBuilderValidators.maxLength(
        length,
        errorText: 'Se aceptan $length caracteres o menos',
      );

  static FormFieldValidator<String> numeric(BuildContext context) =>
      FormBuilderValidators.numeric(errorText: 'El valor debe ser numérico');

  static FormFieldValidator<String> min(int min) => FormBuilderValidators.min(
    min,
    errorText: 'El valor debe ser mayor o igual a $min',
  );

  static FormFieldValidator<String> max(int max) => FormBuilderValidators.max(
    max,
    errorText: 'El valor debe ser menor o igual a $max',
  );
}
