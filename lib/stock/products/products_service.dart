import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_models.dart';

class ProductsService extends ServiceRepository {
  ProductsService(super.db, {required super.table});

  final C = ProductsCompanion.new;

  Future<ProductsList> getProducts() async {
    final $categories = db.categories.actualTableName;
    final $units = db.units.actualTableName;
    final $products = db.products.actualTableName;

    // ignore: non_constant_identifier_names
    final category_name = 'category_name';
    // ignore: non_constant_identifier_names
    final unit_count = 'unit_count';

    final $$name = db.categories.name.$name;
    final $$categoryId = db.products.categoryId.$name;
    final $$productId = db.units.productId.$name;

    final query = db.customSelect(
      '''
        SELECT
          p.*,
          c.${$$name} as $category_name,
          COUNT(u.id) as $unit_count
        FROM ${$products} p
        LEFT JOIN ${$categories} c ON c.id = p.${$$categoryId}
        LEFT JOIN ${$units} u ON u.${$$productId} = p.id
        GROUP BY p.id
      ''',
      readsFrom: {db.products, db.categories, db.units},
    );

    final rows = await stall(query.get());

    return rows.map((row) {
      final unitsCount = row.read<int>(unit_count);
      final usesDetailedUnits = row.read<bool>(
        db.products.usesDetailedUnits.$name,
      );
      final categoryId = row.read<int?>(db.products.categoryId.$name);

      return ProductWithDetails(
        id: row.read<int>(db.products.id.$name),
        code: row.read<String>(db.products.code.$name),
        name: row.read<String>(db.products.name.$name),
        units: usesDetailedUnits
            ? unitsCount
            : row.read<int>(db.products.units.$name),
        usesDetailedUnits: usesDetailedUnits,
        categoryId: categoryId,
        categoryName: row.read<String?>(category_name),
      );
    }).toList();
  }

  /// Fetches the names of all categories to use in the select widget
  Future<TableForeignKeyOptions> fetchCategoryNames() async {
    return await (db.selectOnly(db.categories)
          ..addColumns([db.categories.name, db.categories.id])
          ..orderBy([OrderingTerm.asc(db.categories.name)]))
        .map(
          (row) => (
            label: row.read(db.categories.name)!,
            id: row.read(db.categories.id)!,
          ),
        )
        .get();
  }

  Future<ProductCountsByCategory> fetchProductsCountsByCategory() async {
    final $products = db.products.actualTableName;
    final $$categoryId = db.products.categoryId.$name;

    // ignore: non_constant_identifier_names
    final no_category = 'no_category';
    // ignore: non_constant_identifier_names
    final with_category = 'with_category';

    final query = db.customSelect('''
      SELECT
        COUNT(CASE WHEN ${$$categoryId} IS NULL THEN 1 ELSE NULL END) as $no_category,
        COUNT(CASE WHEN ${$$categoryId} IS NOT NULL THEN 1 ELSE NULL END) as $with_category
      FROM ${$products} 
    ''');

    final row = await query.getSingle();

    return (
      noCategory: row.read<int>(no_category),
      withCategory: row.read<int>(with_category),
    );
  }

  Future<ProductWithDetails> addProduct(AddProductInput data) async {
    final op = stall(
      db
          .into(db.products)
          .insertReturning(
            ProductsCompanion.insert(
              code: data.code,
              name: data.name,
              units: Value(data.units ?? 0),
              usesDetailedUnits: Value(data.usesDetailedUnits),
              categoryId: Value(data.categoryId),
            ),
          ),
      const .new(milliseconds: 250),
    );

    final product = await expectDBError(
      op,
      'No se pudo crear el producto',
      onSqliteException: (error) {
        return error.extendedResultCode == ServiceRepository.uniqueConflict
            ? 'Ya existe un producto con ese código'
            : null;
      },
    );

    return ProductWithDetails.fromProduct(product);
  }

  Future<int> deleteProduct(int id) async {
    return await delete(id, C, 'No se pudo eliminar el producto');
  }

  Future<int> changeProductCategoryId(int id, int newCategoryId) async {
    return await update(
      id,
      C,
      C(categoryId: Value(newCategoryId)),
      defaultFailMsg: 'Categoría no actualizada',
    );
  }

  Future<int> renameProduct(int id, String newName) async {
    return await update(
      id,
      C,
      C(name: Value(newName)),
      defaultFailMsg: 'Nombre no actualizado',
      uniqueFailMsg: 'Ya existe un producto con ese nombre',
    );
  }

  Future<int> changeProductCode(int id, String newCode) async {
    return await update(
      id,
      C,
      C(code: Value(newCode)),
      defaultFailMsg: 'Código no actualizado',
      uniqueFailMsg: 'El código debe ser único',
    );
  }

  Future<int> changeProductUnits(int id, int newUnits) async {
    return await update(
      id,
      C,
      C(units: Value(newUnits)),
      defaultFailMsg: 'Unidades no actualizadas',
    );
  }
}
