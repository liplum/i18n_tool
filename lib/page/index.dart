import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class IndexPage extends ConsumerStatefulWidget {
  const IndexPage({super.key});

  @override
  ConsumerState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget buildSidebar() {
    return Placeholder();
  }
}
