import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

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

  late final categoryId = integer().nullable().references(
    Categories,
    #id,
    onDelete: .setNull,
  )();
}

class ProductWithDetails extends Product {
  final String? categoryName;

  ProductWithDetails({
    required this.categoryName,
    required super.id,
    required super.code,
    required super.name,
    required super.units,
    required super.usesDetailedUnits,
    super.categoryId,
  });

  @override
  ProductWithDetails copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? code,
    String? name,
    int? units,
    bool? usesDetailedUnits,
    Value<int?> categoryId = const Value.absent(),
    String? categoryName,
    int? unitsCount,
  }) {
    return ProductWithDetails(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      units: units ?? this.units,
      usesDetailedUnits: usesDetailedUnits ?? this.usesDetailedUnits,
      categoryId: categoryId.present ? categoryId.value : this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  factory ProductWithDetails.fromProduct(
    Product product, {
    String? categoryName,
  }) {
    return ProductWithDetails(
      id: product.id,
      code: product.code,
      name: product.name,
      units: product.units,
      usesDetailedUnits: product.usesDetailedUnits,
      categoryId: product.categoryId,
      categoryName: categoryName,
    );
  }
}
