import 'package:yaml/yaml.dart';

import '../data.dart';
import '../serializer.dart';

class YamlL10nSerializer implements L10nSerializer {
  const YamlL10nSerializer();

  @override
  L10nData parse(String content) {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nSerializationException();
    return L10nData.fromHierarchy(yaml);
  }
}
