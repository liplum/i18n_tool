import 'dart:convert';

import 'package:i18n_tool/parser/parser.dart';

class JsonL10nParser implements L10nParser {
  @override
  L10nCollection parse(String content) {
    final json = jsonDecode(content);
    if (json is! Map) throw L10nFileParseException();
    return L10nCollection.fromHierarchy(json.cast<String, dynamic>());
  }
}