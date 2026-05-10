import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

class ProductsFormBaseVm extends ModalFormWithAsyncValidation {
  final AppDatabase db;

  ProductsFormBaseVm(this.db);

  ProductsAddMutation? mutation;

  final usesDetailedUnits = Signal(false, autoDispose: false);

  @override
  disposeSignals() {
    super.disposeSignals();
    usesDetailedUnits.dispose();
  }

  dynamic getValue(String key) {
    final val = formKey.currentState!.fields[key]?.value;

    if (val.runtimeType == String) return val.trim();

    return val;
  }
}

class ProductsFormVm extends ProductsFormBaseVm with Validation {
  ProductsFormVm(super.db);

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    return ProductsFormVm(db);
  });

  Future<dynamic> submit(BuildContext modalContext) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final name = getValue(ProductFormFields.name.name);
    final code = getValue(ProductFormFields.code.name);

    final errors = await stall(
      Future.wait([checkNameExists(name), checkCodeExists(code)]),
      const .new(milliseconds: 250),
    );

    if (errors.any((e) => e)) return isSubmitting.value = false;

    try {
      await mutation!.mutateAsync((
        name: name,
        code: code,
        categoryId: getValue('categoryId'),
        units: getValue('units'),
        usesDetailedUnits: getValue('usesDetailedUnits'),
      ));

      if (modalContext.mounted) Navigator.of(modalContext).pop();
    } catch (e) {
      //
    } finally {
      isSubmitting.value = false;
    }
  }
}

mixin Validation on ProductsFormBaseVm {
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
