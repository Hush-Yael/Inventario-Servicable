import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';

class Units extends Table {
  late final id = integer().autoIncrement()();

  late final identifier = text().unique().withLength(
    min: kUnitIdentifierMinLength,
    max: kUnitIdentifierMaxLength,
  )();

  late final details = text().nullable().withLength(
    min: kUnitDetailsMinLength,
    max: kUnitDetailsMaxLength,
  )();

  late final soldTo = text().nullable().withLength(
    min: kSoldToMinLength,
    max: kSoldToMaxLength,
  )();

  late final productId = integer().nullable().references(
    Products,
    #id,
    onDelete: .setNull,
  )();
}
