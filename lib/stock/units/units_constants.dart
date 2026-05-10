import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:servicable_stock/core/utils/validators.dart';

enum UnitsTableColumns { identifier, category, product, soldTo, details }

enum UnitFormFields { identifier, productId, details, soldTo }

enum UnitsMetaKeys { productId }

class UnitValidators {
  static final identifier = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kUnitIdentifierMinLength),
    Validators.maxLength(kUnitIdentifierMaxLength),
  ]);

  static final details = FormBuilderValidators.skipWhen(
    (String? v) => v == null || v.isEmpty,
    FormBuilderValidators.compose([
      Validators.minLength(kUnitDetailsMinLength),
      Validators.maxLength(kUnitDetailsMaxLength),
    ]),
  );

  static final soldTo = FormBuilderValidators.skipWhen(
    (String? v) => v == null || v.isEmpty,
    FormBuilderValidators.compose([
      Validators.minLength(kSoldToMinLength),
      Validators.maxLength(kSoldToMaxLength),
    ]),
  );

  static final productId = FormBuilderValidators.compose([
    Validators.required,
    FormBuilderValidators.numeric(),
    Validators.min(1),
  ]);
}

const kUnitsQueryKey = ['units'];

/// Used in a query to get all the product names for units edit cell option selection
const kUnitsProductOptionsQueryKey = ['productNames'];

const kUnitIdentifierMinLength = 6;
const kUnitIdentifierMaxLength = 255;

const kUnitDetailsMinLength = 3;
const kUnitDetailsMaxLength = 512;

const kSoldToMinLength = 3;
const kSoldToMaxLength = 128;
