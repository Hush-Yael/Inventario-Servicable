import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/shared/fn/mutations/single_add.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'package:trina_grid/trina_grid.dart';

typedef ProductsList = List<ProductWithDetails>;

typedef ProductsQuery = QueryResult<ProductsList, dynamic>;

typedef ProductsAddMutation =
    SingleAddMutation<AddProductInput, ProductWithDetails>;

typedef AddProductInput = ({
  String code,
  String name,
  bool usesDetailedUnits,
  int? units,
  // String? unitIdentifier,
  int? categoryId,
});

typedef ProductsDeleteMutation =
    MutationResult<dynamic, Object?, TrinaColumnRendererContext, int>;

typedef ProductsCountsByCategory = ({int noCategory, int withCategory});

typedef ProductCategoryOption = ({String name, int id});

typedef ProductCategoryOptions = List<ProductCategoryOption?>;
