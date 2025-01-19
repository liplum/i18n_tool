import 'dart:convert';

import '../collection.dart';
import '../parser.dart';

class JsonL10nParser implements L10nParser {
  const JsonL10nParser();

  @override
  L10nData parse(String content) {
    final json = jsonDecode(content);
    if (json is! Map) throw L10nFileParseException();
    return L10nData.fromHierarchy(json);
  }
}
