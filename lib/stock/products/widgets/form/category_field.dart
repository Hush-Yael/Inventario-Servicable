import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/widgets/field.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';

class CategoryField extends HookWidget {
  const CategoryField({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ProductsVm.instance.of(context);

    final queryClient = useQueryClient();

    final categories = Resource(
      () => queryClient.ensureQueryData<ProductCategoryOptions, dynamic>(
        kCategoryNamesQueryKey,
        (_) => vm.service.fetchCategoryNames(),
      ),
    );

    return SignalBuilder(
      builder: (context, child) => categories.state.when(
        error: (error, trace) => errorWidget(error, trace, context),
        loading: loader,
        ready: (categories) => builder(categories, context),
      ),
    );
  }

  Widget loader() => const Align(
    alignment: .center,
    child: Column(
      spacing: 20,
      crossAxisAlignment: .stretch,
      children: [Text('Cargando categorías...'), ProgressBar(strokeWidth: 6)],
    ),
  );

  Widget builder(ProductCategoryOptions categories, BuildContext context) {
    final formVm = ProductsFormVm.instance.of(context);

    return Field(
      'categoryId',
      label: 'Categoría',
      initialValue: categories.first?.id,
      childBuilder: (field) {
        return SignalBuilder(
          builder: (context, child) => ComboboxFormField<ProductCategoryOption>(
            style: AppTheme.fixedTextHeightStyle,
            value: categories.firstWhereOrNull((c) => c!.id == field.value),
            validator: (v) => ProductValidators.categoryId(v?.id.toString()),
            items: categories
                .map((c) => ComboBoxItem(value: c, child: Text(c!.name)))
                .toList(),
            onChanged: !formVm.enabled ? null : (v) => field.didChange(v!.id),
          ),
        );
      },
    );
  }

  Widget errorWidget(Object error, StackTrace? trace, BuildContext context) {
    final errorColor = AppTheme.errorColor(context);

    return Tooltip(
      message: error.toString(),
      child: Column(
        spacing: 5,
        children: [
          Row(
            spacing: 10,
            children: [
              WindowsIcon(FluentIcons.incident_triangle, color: errorColor),

              Text(
                'Error al obtener las categorías',
                style: .new(color: errorColor),
              ),
            ],
          ),

          Container(
            decoration: BoxDecoration(color: errorColor.withAlpha(20)),
            height: 30,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
