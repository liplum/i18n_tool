import 'package:i18n_tool/parser/parser.dart';
import 'package:properties/properties.dart';

class PropertiesL10nParser implements FlatListL10nParser {
  @override
  FlatList parse(String content) {
    final pairs = <({String key, String value})>[];
    final properties = Properties.fromString(content);
    for (final key in properties.keys) {
      final value = properties.get(key);
      if (value != null) {
        pairs.add((key: key, value: value));
      }
    }
    return FlatList.create(pairs: pairs);
  }
}
