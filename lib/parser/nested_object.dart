import 'dart:convert';

import 'package:i18n_tool/parser/parser.dart';
import 'package:yaml/yaml.dart';

class JsonL10nParser implements NestedObjectL10nParser {
  @override
  NestedObject parse(String content) {
    final json = jsonDecode(content);
    if (json is! Map) throw L10nFileParseException();
    return NestedObject.transform(json.cast<String, dynamic>());
  }
}

class YamlL10nParser implements NestedObjectL10nParser {
  @override
  NestedObject parse(String content) {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nFileParseException();
    return NestedObject.transform(yaml.cast<String, dynamic>());
  }
}
