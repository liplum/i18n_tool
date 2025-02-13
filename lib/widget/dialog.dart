import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

extension BuildContextDialogEx on BuildContext {
  Future<bool?> showDialogRequest({
    required String title,
    required String desc,
    required String primary,
    required String secondary,
  }) async {
    final result = await showDialog(
      context: this,
      builder: (context) => ContentDialog(
        title: title.text(),
        content: desc.text(),
        actions: [
          Button(
            child: secondary.text(),
            onPressed: () => context.pop(true),
          ),
          FilledButton(
            child: primary.text(),
            onPressed: () => context.pop(true),
          ),
        ],
      ),
    );
    if (result == null) return null;
    return result == true;
  }
}
