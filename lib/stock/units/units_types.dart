import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/shared/fn/mutations/single_add.dart';
import 'package:servicable_stock/stock/units/units_models.dart';
import 'package:trina_grid/trina_grid.dart';

typedef UnitsList = List<UnitWithDetails>;

typedef UnitsQuery = QueryResult<UnitsList, dynamic>;

typedef AddUnitInput = ({
  String identifier,
  String? details,
  String? soldTo,
  int? productId,
});

typedef UnitsAddMutation = SingleAddMutation<AddUnitInput, UnitWithDetails>;

typedef UnitsDeleteMutation =
    MutationResult<dynamic, Object?, TrinaColumnRendererContext, int>;

typedef ProductForeignKeyOption = ({
  String label,
  int id,
  String? categoryName,
});

typedef ProductForeignKeyOptions = List<ProductForeignKeyOption>;
