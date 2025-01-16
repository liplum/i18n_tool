import 'package:flutter/material.dart';

import 'index.dart';

class I18nToolApp extends StatefulWidget {
  const I18nToolApp({super.key});

  @override
  State<I18nToolApp> createState() => _I18nToolAppState();
}

class _I18nToolAppState extends State<I18nToolApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const PlatformMenuBarExample(),
      ),
    );
  }
}
