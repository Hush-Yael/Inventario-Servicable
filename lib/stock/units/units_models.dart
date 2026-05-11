import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/shared/shared_models.dart';
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

class UnitWithDetails extends Unit {
  final String? categoryName;
  final String? productName;

  UnitWithDetails({
    required super.id,
    required super.identifier,
    super.details,
    super.soldTo,
    super.productId,
    this.categoryName,
    this.productName,
  });

  UnitWithDetails.fromUnit(
    Unit unit, {
    String? categoryName,
    String? productName,
  }) : this(
         id: unit.id,
         identifier: unit.identifier,
         details: unit.details,
         soldTo: unit.soldTo,
         productId: unit.productId,
         categoryName: categoryName,
         productName: productName,
       );

  @override
  Unit copyWith({
    int? id,
    String? identifier,
    Value<String?> details = const Value.absent(),
    Value<String?> soldTo = const Value.absent(),
    Value<int?> productId = const Value.absent(),
    String? categoryName,
    String? productName,
  }) {
    return UnitWithDetails(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      details: details.present ? details.value : this.details,
      soldTo: soldTo.present ? soldTo.value : this.soldTo,
      productId: productId.present ? productId.value : this.productId,
      categoryName: categoryName ?? this.categoryName,
      productName: productName ?? this.productName,
    );
  }
}

class ProductForeignKeyOption extends TableForeignKeyOption {
  const ProductForeignKeyOption({
    required super.label,
    required super.id,
    this.categoryName,
  });

  final String? categoryName;
}
