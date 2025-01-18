import 'package:i18n_tool/parser/parser.dart';
import 'package:yaml/yaml.dart';

class YamlL10nParser implements L10nParser {
  @override
  L10nCollection parse(String content) {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nFileParseException();
    return L10nCollection.fromHierarchy(yaml.cast<String, dynamic>());
  }
}
