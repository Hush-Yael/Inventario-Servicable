import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

class ProductsFormBaseVm {
  final AppDatabase db;
  final GlobalKey<FormBuilderState> formKey;

  ProductsFormBaseVm(this.db, this.formKey);

  ProductsAddMutation? mutation;
  bool nameExists = false;
  bool codeExists = false;

  bool get enabled => !isSubmitting.value;
  bool get invalid => formKey.currentState!.validate() != true;

  final isSubmitting = Signal(false, autoDispose: false);
  final usesDetailedUnits = Signal(false, autoDispose: false);

  void useAutoDispose() {
    useEffect(() {
      return () {
        isSubmitting.dispose();
        usesDetailedUnits.dispose();
      };
    }, []);
  }

  dynamic getValue(String key) {
    final val = formKey.currentState!.fields[key]?.value;

    if (val.runtimeType == String) return val.trim();

    return val;
  }
}

class ProductsFormVm extends ProductsFormBaseVm with Validation {
  ProductsFormVm(super.db, super.formKey);

  static final instance = Provider.withArgument((
    ctx,
    GlobalKey<FormBuilderState> formKey,
  ) {
    final db = AppDatabase.instance.of(ctx);
    return ProductsFormVm(db, formKey);
  });

  Future<void> submit([dynamic fieldValue]) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final name = getValue(ProductFormFields.name.name);
    final code = getValue(ProductFormFields.code.name);

    await Future.wait([checkNameExists(name), checkCodeExists(code)]);

    // check again to catch async errors
    if (invalid) {
      isSubmitting.value = false;
      return;
    }

    try {
      await mutation!.mutateAsync((
        name: name,
        code: code,
        categoryId: getValue('categoryId'),
        // unitIdentifier: getValue('unitIdentifier'),
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
    final product =
        await (db.select(db.products)
              ..limit(1)
              ..where((p) => db.products.name.equals(name)))
            .getSingleOrNull();

    return nameExists = product != null;
  }

  Future<bool> checkCodeExists(String code) async {
    final product =
        await (db.select(db.products)
              ..limit(1)
              ..where((p) => db.products.code.equals(code)))
            .getSingleOrNull();

    return codeExists = product != null;
  }

  TextEditingController useAsyncValidation(
    Future<bool> Function(String text) check,
    String field,
  ) {
    final controller = useTextEditingController();

    listener() {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        check(text).then((exists) {
          if (exists) {
            formKey.currentState!.fields[field]?.validate();
          }
        });
      }
    }

    useEffect(() {
      controller.addListener(listener);

      return () {
        controller.removeListener(listener);
      };
    }, [controller]);

    return controller;
  }

  String? validateWithAsync(
    String? value, {
    required String? Function(String?) validator,
    required Future<bool> Function(String) check,
    required bool errorRef,
    required String? asyncErrorMsg,
  }) {
    final error = validator(value);

    if (error != null) return error;

    if (errorRef) return asyncErrorMsg;

    return null;
  }
}
