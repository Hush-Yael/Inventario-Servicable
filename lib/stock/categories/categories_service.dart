import 'dart:async';

import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';

class CategoriesService extends ServiceRepository {
  CategoriesService(super.db);

  Future<CategoriesList> fetchCategories() async {
    final $categories = db.categories.actualTableName;
    final $products = db.products.actualTableName;
    final $units = db.units.actualTableName;
    final $productCount = 'productCount';
    final $unitCount = 'unitCount';

    final categories = await stall(
      db
          .customSelect(
            '''
              SELECT 
                c.*,
                COUNT(p.id) as ${$productCount},
                CASE
                  WHEN p.${db.products.usesUnits.$name} = 0 THEN ${db.products.stock.$name}
                  ELSE COUNT(u.id)
                END as ${$unitCount}
              FROM ${$categories} c
              LEFT JOIN ${$products} p ON p.${db.products.category.$name} = c.id
              LEFT JOIN ${$units} u ON u.${db.units.product.$name} = p.id
              GROUP BY c.id
            ''',
            readsFrom: {db.categories, db.products, db.units},
          )
          .get(),
    );

    return categories.map((row) {
      return CategoryWithCounts(
        id: row.read(db.categories.id.name),
        name: row.read(db.categories.name.name),
        createdAt: row.read(db.categories.createdAt.name),
        updatedAt: row.read(db.categories.updatedAt.name),
        productCount: row.read($productCount),
        unitCount: row.read($unitCount),
      );
    }).toList();
  }

  Future<int> deleteCategory(int id) async {
    final op = (db.delete(
      db.categories,
    )..whereSamePrimaryKey(CategoriesCompanion(id: Value(id)))).go();

    return await ensureMutated(op, 'No se pudo eliminar la categoría');
  }

  String? validateCategoryNameLength(String input) {
    final invalidMinLength = input.length < kCategoryNameMinLength;

    if (invalidMinLength || input.length > kCategoryNameMaxLength) {
      return invalidMinLength
          ? 'El nombre de la categoría debe tener al menos $kCategoryNameMinLength caracteres'
          : 'El nombre de la categoría acepta $kCategoryNameMaxLength caracteres máximos';
    }

    return null;
  }

  Future<Category> addCategory(String name) async {
    final op = stall(
      db
          .into(db.categories)
          .insertReturning(CategoriesCompanion.insert(name: name)),
    );

    return await expectDBError(
      op,
      'No se pudo crear la categoría',
      onSqliteException: (error) =>
          error.extendedResultCode == ServiceRepository.uniqueConflict
          ? 'Ya existe una categoría con el mismo nombre'
          : null,
    );
  }

  Future<int> updateCategoryName(int id, String newName) async {
    final trimmed = newName.trim();

    final invalidName = validateCategoryNameLength(trimmed);

    if (invalidName != null) throw Exception(invalidName);

    final op =
        (db.update(
          db.categories,
        )..whereSamePrimaryKey(CategoriesCompanion(id: Value(id)))).write(
          CategoriesCompanion(
            name: Value(trimmed),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return await expectDBError(
      op,
      'No se pudo actualizar el nombre de la categoría',
      onSqliteException: (error) =>
          error.extendedResultCode == ServiceRepository.uniqueConflict
          ? 'Ese nombre de categoría ya existe'
          : null,
    );
  }
}
