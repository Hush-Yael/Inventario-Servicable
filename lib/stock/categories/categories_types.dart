import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:trina_grid/trina_grid.dart';

typedef CategoriesList = List<CategoryWithCounts>;

typedef CategoriesQuery = QueryResult<CategoriesList, dynamic>;

typedef CategoriesAddMutation =
    MutationResult<
      int,
      Object?,
      String,
      ({TrinaRow row, CategoryWithCounts cat})
    >;

typedef CategoriesChangeNameMutation =
    MutationResult<dynamic, Object?, TrinaGridOnChangedEvent, DateTime>;

typedef CategoriesDeleteMutation =
    MutationResult<dynamic, Object?, TrinaColumnRendererContext, int>;
