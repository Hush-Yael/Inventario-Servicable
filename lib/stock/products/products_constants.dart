import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:servicable_stock/core/utils/validators.dart';

enum ProductTableColumns { category, code, name, units, createdAt, updatedAt }

enum ProductMetaKeys { usesDetailedUnits, categoryId }

enum ProductFormFields { code, name, usesDetailedUnits, categoryId, units }

enum CategoryFilterValue { all, withCategory, withoutCategory }

const kProductsQueryKey = ['products'];

/// Used in a query to get all the category names for products edit cell option selection
const kProductsCategoryOptionsQueryKey = ['categoryNames'];

const kProductCountsQueryKey = ['productsCounts'];

class ProductValidators {
  static final code = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kProductCodeMinLength),
    Validators.maxLength(kProductCodeMaxLength),
  ]);

  static final name = FormBuilderValidators.compose([
    Validators.required,
    Validators.minLength(kProductNameMinLength),
    Validators.maxLength(kProductNameMaxLength),
  ]);

  static final units = FormBuilderValidators.compose([
    Validators.required,
    Validators.numeric(),
    Validators.min(0),
  ]);

  static final categoryId = FormBuilderValidators.compose([
    Validators.required,
    Validators.numeric(),
    Validators.min(1),
  ]);
}

const kProductCodeMinLength = 6;
const kProductCodeMaxLength = 64;

const kProductNameMinLength = 3;
const kProductNameMaxLength = 128;
