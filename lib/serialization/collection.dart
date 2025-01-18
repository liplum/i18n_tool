import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

const keyPathSeparator = ".";

@immutable
abstract class L10nData {
  String? get(String key);

  L10nData set(String key, String? value);

  factory L10nData.create({
    required List<({String key, String value})> pairs,
  }) {
    return _FlatL10nList(pairs: pairs);
  }

  factory L10nData.fromHierarchy(Map<String, dynamic> hierarchy) {
    final pairs = <({String key, String value})>[];
    void visit(String? parent, Map<dynamic, dynamic> tree) {
      final result = <String, dynamic>{};
      for (final MapEntry(:key, :value) in tree.entries) {
        if (value is String) {
          result[key] = value;
        } else if (value is Map) {
          visit(parent == null ? key : "$parent$keyPathSeparator$key", value);
        }
      }
    }

    visit(null, hierarchy);
    return _FlatL10nList(pairs: pairs);
  }
}

@immutable
class _FlatL10nList implements L10nData {
  final List<({String key, String value})> pairs;

  const _FlatL10nList({
    required this.pairs,
  });

  @override
  String? get(String key) {
    final pair = pairs.firstWhereOrNull((it) => it.key == key);
    return pair?.value;
  }

  @override
  L10nData set(String key, String? value) {
    final index = pairs.indexWhere((it) => it.key == key);
    if (index < 0) {
      if (value != null) {
        return _FlatL10nList(pairs: [...pairs, (key: key, value: value)]);
      }
    } else {
      if (value == null) {
        return _FlatL10nList(pairs: [...pairs]..removeAt(index));
      } else {
        return _FlatL10nList(pairs: [...pairs]..[index] = (key: key, value: value));
      }
    }
    return this;
  }
}
