import 'package:collection/collection.dart';
import 'package:i18n_tool/parser/parser.dart';

abstract class FlatList {
  const FlatList();

  String? get(String key);

  void set(String key, String? value);
}

class _FlatList implements FlatList {
  final List<({String key, String value})> pairs;

  const _FlatList({
    required this.pairs,
  });

  @override
  String? get(String key) {
    final pair = pairs.firstWhereOrNull((it) => it.key == key);
    return pair?.value;
  }

  @override
  void set(String key, String? value) {
    final index = pairs.indexWhere((it) => it.key == key);
    if (index < 0) {
      if (value != null) {
        pairs.add((key: key, value: value));
      }
    } else {
      if (value == null) {
        pairs.removeAt(index);
      } else {
        pairs[index] = (key: key, value: value);
      }
    }
  }
}

abstract class FlatListL10nParser implements L10nParser<FlatList> {}

class PropertiesL10nParser implements FlatListL10nParser {
  @override
  Future<FlatList> parse(String content) async {
    throw UnimplementedError();
  }
}
