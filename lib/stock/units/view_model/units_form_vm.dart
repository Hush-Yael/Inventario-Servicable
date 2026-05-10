import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';
import 'package:servicable_stock/stock/units/units_models.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';

class UnitsFormVm
    extends ModalFormWithAsyncValidation<AddUnitInput, UnitWithDetails> {
  UnitsFormVm(super.db);

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    return UnitsFormVm(db);
  });

  @override
  getFormData() {
    return (
      identifier: getValue<String>(UnitFormFields.identifier.name),
      details: getValue<String?>(UnitFormFields.details.name),
      soldTo: getValue<String?>(UnitFormFields.soldTo.name),
      productId: getValue<int?>(UnitFormFields.productId.name),
    );
  }

  @override
  checkAsyncErrorsBeforeSubmit() async {
    final identifier = getValue<String>(UnitFormFields.identifier.name);

    return await checkIdentifierExists(identifier);
  }

  Future<bool> checkIdentifierExists(String identifier) async {
    return await _checkUnit(
      (p) => db.units.identifier.equals(identifier),
      UnitFormFields.identifier.name,
      'Ya existe una unidad con ese identificador',
    );
  }

  Future<bool> _checkUnit(
    Expression<bool> Function($UnitsTable) filter,
    String field,
    String errorMsg,
  ) async {
    final unit =
        await (db.select(db.units)
              ..limit(1)
              ..where(filter))
            .getSingleOrNull();

    final isError = unit != null;

    if (isError) {
      formKey.currentState!.fields[field]!.invalidate(
        errorMsg,
        shouldFocus: false,
      );
    }

    return isError;
  }
}
