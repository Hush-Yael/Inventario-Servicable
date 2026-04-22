import 'package:disco/disco.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/categories/categories_service.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_add_mixin.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_change_name_mixin.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_delete_mixin.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_table_mixin.dart';

class CategoriesBaseVm with VmTrinaGridMixin {
  final bool isAdmin;
  final CategoriesService service;

  CategoriesBaseVm(this.service, {required this.isAdmin});
}

class CategoriesVm extends CategoriesBaseVm
    with TableMixin, ChangeNameMixin, DeleteMixin, AddMixin {
  CategoriesVm(super.service, {required super.isAdmin});

  static final instance = Provider((context) {
    final db = AppDatabase.instance.of(context);
    final service = CategoriesService(db);

    return CategoriesVm(service, isAdmin: utils.isAdmin(context));
  });
}
