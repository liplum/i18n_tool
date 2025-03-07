import 'package:properties/properties.dart';

import '../data.dart';
import '../serializer.dart';

class PropertiesL10nSerializer implements L10nSerializer {
  const PropertiesL10nSerializer();

  @override
  L10nData deserialize(String content, SerializationSettings settings) {
    final pairs = <({String key, String value})>[];
    final properties = Properties.fromString(content);
    for (final key in properties.keys) {
      final value = properties.get(key);
      if (value != null) {
        pairs.add((key: key, value: value));
      }
    }
    return L10nData.create(pairs: pairs);
  }

  @override
  String serialize(L10nData data, SerializationSettings settings) {
    final buff = StringBuffer();
    for (final (:key, :value) in data) {
      buff.write("$key = $value");
      buff.write('\n');
    }
    return buff.toString();
  }
}
