import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';

@DataClassName('Category')
class Categories extends Table with TimeStampedRecord {
  late final id = integer().autoIncrement()();

  late final name = text().unique().withLength(
    min: kCategoryNameMinLength,
    max: kCategoryNameMaxLength,
  )();
}

class CategoryWithCounts extends Category {
  final int? productCount;
  final int? unitCount;

  CategoryWithCounts({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required this.productCount,
    required this.unitCount,
  });

  @override
  CategoryWithCounts copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? productCount,
    int? unitCount,
  }) {
    return CategoryWithCounts(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productCount: productCount ?? this.productCount,
      unitCount: unitCount ?? this.unitCount,
    );
  }
}
