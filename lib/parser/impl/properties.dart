import 'package:i18n_tool/parser/parser.dart';
import 'package:properties/properties.dart';

class PropertiesL10nParser implements L10nParser {
  @override
  L10nCollection parse(String content) {
    final pairs = <({String key, String value})>[];
    final properties = Properties.fromString(content);
    for (final key in properties.keys) {
      final value = properties.get(key);
      if (value != null) {
        pairs.add((key: key, value: value));
      }
    }
    return L10nCollection.create(pairs: pairs);
  }
}
