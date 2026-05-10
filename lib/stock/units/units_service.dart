import 'package:drift/drift.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/services_repository.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/stock/units/units_models.dart';
import 'package:servicable_stock/stock/units/units_types.dart';

class UnitsService extends ServiceRepository {
  const UnitsService(super.db, {required super.table});

  Future<UnitsList> getUnits() async {
    final $categories = db.categories.actualTableName;
    final $units = db.units.actualTableName;
    final $products = db.products.actualTableName;

    // ignore: non_constant_identifier_names
    final category_name = 'category_name';
    // ignore: non_constant_identifier_names
    final product_name = 'product_name';
    // ignore: non_constant_identifier_names
    final product_id = 'product_id';

    final $$categoryName = db.categories.name.$name;
    final $$productId = db.units.productId.$name;
    final $$productName = db.products.name.$name;
    final $$categoryId = db.products.categoryId.$name;

    final query = db.customSelect(
      '''
        SELECT
          u.*,
          c.${$$categoryName} as $category_name,
          p.id as $product_id,
          p.${$$productName} as $product_name
        FROM ${$units} u
        LEFT JOIN ${$products} p ON p.id = u.${$$productId}
        LEFT JOIN ${$categories} c ON c.id = p.${$$categoryId}
        GROUP BY c.id, p.id, u.id;
      ''',
      readsFrom: {db.products, db.categories, db.units},
    );

    final rows = await stall(query.get());

    return rows.map((row) {
      return UnitWithDetails(
        id: row.read<int>(db.units.id.$name),
        identifier: row.read<String>(db.units.identifier.$name),
        details: row.read<String?>(db.units.details.$name),
        soldTo: row.read<String?>(db.units.soldTo.$name),
        categoryName: row.read<String?>(category_name),
        productName: row.read<String?>(product_name),
        productId: row.read<int?>(product_id),
      );
    }).toList();
  }

  final C = UnitsCompanion.new;

  Future<int> deleteUnit(int id) async {
    return await delete(id, C, 'No se pudo eliminar el producto');
  }

  Future<ProductForeignKeyOptions> getProductNames([
    QueryFunctionContext? ctx,
  ]) async {
    final result =
        (db.selectOnly(db.products)
            ..addColumns([db.products.id, db.products.name, db.categories.name])
            ..join([
              leftOuterJoin(
                db.categories,
                db.products.id.equalsExp(db.categories.id),
                useColumns: false,
              ),
            ])
            ..groupBy([db.categories.id, db.products.id]))
          ..where(db.products.usesDetailedUnits.equals(true));

    return await result
        .asyncMap(
          (row) => (
            id: row.read<int>(db.products.id)!,
            label: row.read<String>(db.products.name)!,
            categoryName: row.read<String>(db.categories.name),
          ),
        )
        .get();
  }

  Future<int> changeUnitIdentifier(int id, String newIdentifier) async {
    return await update(
      id,
      C,
      C(identifier: Value(newIdentifier)),
      defaultFailMsg: 'Identificador no actualizado',
      uniqueFailMsg: 'El identificador debe ser único',
    );
  }

  Future<int> changeUnitSoldTo(int id, String newIdentifier) {
    return update(
      id,
      C,
      C(soldTo: Value(newIdentifier)),
      defaultFailMsg: 'Adquiriente no actualizado',
    );
  }

  Future<int> changeUnitProduct(int id, int newProductId) {
    return update(
      id,
      C,
      C(productId: Value(newProductId)),
      defaultFailMsg: 'Producto no actualizado',
    );
  }

  Future<UnitWithDetails> addUnit(AddUnitInput input) async {
    final op = stall(
      db
          .into(db.units)
          .insertReturning(
            UnitsCompanion.insert(
              identifier: input.identifier,
              details: Value(input.details),
              soldTo: Value(input.soldTo),
              productId: Value(input.productId),
            ),
          ),
      const .new(milliseconds: 250),
    );

    final unit = await expectDBError(
      op,
      'No se pudo crear el producto',
      onSqliteException: (error) {
        return error.extendedResultCode == ServiceRepository.uniqueConflict
            ? 'Ya existe una unidad con ese identificador'
            : null;
      },
    );

    return UnitWithDetails.fromUnit(unit);
  }

  Future<int> changeUnitDetails(int id, String newDetails) {
    return update(
      id,
      C,
      C(details: Value(newDetails)),
      defaultFailMsg: 'Detalles no actualizados',
    );
  }
}
