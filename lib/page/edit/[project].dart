import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProjectPage extends ConsumerStatefulWidget {
  const EditProjectPage({super.key});

  @override
  ConsumerState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends ConsumerState<EditProjectPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Edit'),
      ),
    );
  }
}
