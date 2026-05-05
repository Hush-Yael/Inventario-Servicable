import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

const kProductUnitIdentifierDefault = 'identificador';

class Products extends Table {
  late final id = integer().autoIncrement()();

  late final code = text().unique().withLength(
    min: kProductCodeMinLength,
    max: kProductCodeMaxLength,
  )();

  late final name = text().unique().withLength(
    min: kProductNameMinLength,
    max: kProductNameMaxLength,
  )();

  late final Column<int> units = integer()
      .check(units.isBiggerOrEqualValue(0))
      .withDefault(const Constant(0))();

  /// whether the product stock depends on individual detailed units or not
  late final usesDetailedUnits = boolean().withDefault(const Constant(true))();

  /// label for the unit identifier field (shown as column header)
  late final unitIdentifier = text().withDefault(
    const Constant(kProductUnitIdentifierDefault),
  )();

  late final categoryId = integer().nullable().references(
    Categories,
    #id,
    onDelete: .setNull,
  )();
}
