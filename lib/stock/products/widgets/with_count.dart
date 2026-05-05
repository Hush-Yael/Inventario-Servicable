import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';

class CategoryFilterOpt extends StatelessWidget {
  final String text;
  final int? count;
  final CategoryFilterValue value;

  const CategoryFilterOpt({
    super.key,
    required this.count,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RadioButton(
      value: value,
      content: Row(
        spacing: 7,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Text(text, style: context.theme.typography.body),

          if (count != null)
            Text(
              '(${count.toString()})',
              style: context.theme.typography.body?.apply(
                color: context.theme.resources.textFillColorTertiary,
              ),
            ),
        ],
      ),
    );
  }
}
