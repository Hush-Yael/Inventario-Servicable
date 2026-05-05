import 'package:disco/disco.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/stock/products/products_service.dart';
import 'package:servicable_stock/stock/products/view_model/product_update_mixin.dart';
import 'package:servicable_stock/stock/products/view_model/products_add_mixin.dart';
import 'package:servicable_stock/stock/products/view_model/products_delete_mixin.dart';

import 'package:servicable_stock/stock/products/view_model/products_table_mixin.dart';

class ProductsBaseVm with VmTrinaGridMixin {
  final bool isAdmin;
  final ProductsService service;

  ProductsBaseVm(this.service, {required this.isAdmin});
}

class ProductsVm extends ProductsBaseVm
    with TableMixin, AddMixin, DeleteMutationMixin, UpdateMutationsMixin {
  ProductsVm(super.service, {required super.isAdmin});

  static final instance = Provider((context) {
    final db = AppDatabase.instance.of(context);
    final service = ProductsService(db, table: db.products);

    return ProductsVm(service, isAdmin: utils.isAdmin(context));
  });
}
