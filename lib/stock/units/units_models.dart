import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';

class Units extends Table with TimeStampedRecord {
  late final id = integer().autoIncrement()();

  late final identifier = text().unique().withLength(
    min: kUnitIdentifierMinLength,
    max: kUnitIdentifierMaxLength,
  )();

  late final details = text().nullable().withLength(
    min: kUnitDetailsMinLength,
    max: kUnitDetailsMaxLength,
  )();

  late final product = integer().nullable().references(
    Products,
    #id,
    onDelete: .setNull,
  )();
}
