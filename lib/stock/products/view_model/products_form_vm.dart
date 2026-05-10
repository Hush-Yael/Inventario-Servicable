import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/products_models.dart';

class ProductsFormVm
    extends ModalFormWithAsyncValidation<AddProductInput, ProductWithDetails> {
  ProductsFormVm(super.db);

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    return ProductsFormVm(db);
  });

  final usesDetailedUnits = Signal(false, autoDispose: false);

  @override
  disposeSignals() {
    super.disposeSignals();
    usesDetailedUnits.dispose();
  }

  @override
  checkAsyncErrorsBeforeSubmit() async {
    final name = getValue(ProductFormFields.name.name);
    final code = getValue(ProductFormFields.code.name);

    final errors = await Future.wait([
      checkNameExists(name),
      checkCodeExists(code),
    ]);

    return (errors.any((e) => e));
  }

  @override
  getFormData() {
    return (
      name: getValue<String>(ProductFormFields.name.name),
      code: getValue<String>(ProductFormFields.code.name),
      categoryId: getValue('categoryId'),
      units: getValue('units'),
      usesDetailedUnits: getValue('usesDetailedUnits'),
    );
  }

  Future<bool> checkNameExists(String name) async {
    return await _checkProduct(
      (p) => db.products.name.equals(name),
      ProductFormFields.name.name,
      'Ya existe un producto con ese nombre',
    );
  }

  Future<bool> checkCodeExists(String code) async {
    return _checkProduct(
      (p) => db.products.code.equals(code),
      ProductFormFields.code.name,
      'El código debe ser único',
    );
  }

  Future<bool> _checkProduct(
    Expression<bool> Function($ProductsTable) filter,
    String field,
    String errorMsg,
  ) async {
    final product =
        await (db.select(db.products)
              ..limit(1)
              ..where(filter))
            .getSingleOrNull();

    final isError = product != null;

    if (isError) {
      formKey.currentState!.fields[field]!.invalidate(
        errorMsg,
        shouldFocus: false,
      );
    }

    return isError;
  }
}
