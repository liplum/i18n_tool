import 'package:yaml/yaml.dart';

import '../data.dart';
import '../parser.dart';

class YamlL10nParser implements L10nParser {
  const YamlL10nParser();

  @override
  L10nData parse(String content) {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nFileParseException();
    return L10nData.fromHierarchy(yaml);
  }
}
