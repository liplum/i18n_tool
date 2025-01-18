import 'package:properties/properties.dart';

import '../collection.dart';
import '../parser.dart';

class PropertiesL10nParser implements L10nParser {
  const PropertiesL10nParser();

  @override
  L10nData parse(String content) {
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
}
