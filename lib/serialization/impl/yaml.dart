import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../data.dart';
import '../serializer.dart';

class YamlL10nSerializer implements L10nSerializer {
  const YamlL10nSerializer();

  @override
  L10nData deserialize(String content, SerializationSettings settings) {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nSerializationException();
    return L10nData.fromHierarchy(yaml);
  }

  @override
  String serialize(L10nData data, SerializationSettings settings) {
    final object = data.toNestedObject();
    final encoder = YamlWriter(
      allowUnquotedStrings: !settings.forceQuotedString,
    );
    final encoded = encoder.write(object);
    return encoded;
  }
}
