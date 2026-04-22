import 'package:fluent_ui/fluent_ui.dart';

class NoRows extends StatelessWidget {
  final String modelName;
  const NoRows(this.modelName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          const WindowsIcon(FluentIcons.delete_table, size: 40),

          Text(
            'No se encontraron $modelName',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
