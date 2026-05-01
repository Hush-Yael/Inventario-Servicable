import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

class Products extends Table with TimeStampedRecord {
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

  /// whether the product stock is set manually or it depends on units
  late final usesUnits = boolean().withDefault(const Constant(true))();

  /// label for the unit identifier field (shown as column header)
  late final unitIdentifier = text().withDefault(
    const Constant('identificador'),
  )();

  late final categoryId = integer().nullable().references(
    Categories,
    #id,
    onDelete: .setNull,
  )();
}
