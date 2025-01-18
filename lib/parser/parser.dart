import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

class L10nFileParseException implements Exception {
  final Exception? cause;

  const L10nFileParseException({
    this.cause,
  });
}

abstract class L10nParser {
  L10nCollection parse(String content);
}

abstract class L10nParserPlugin {}

const keyPathSeparator = ".";

@immutable
abstract class L10nCollection {
  String? get(String key);

  L10nCollection set(String key, String? value);

  factory L10nCollection.create({
    required List<({String key, String value})> pairs,
  }) {
    return _FlatL10nList(pairs: pairs);
  }

  factory L10nCollection.fromHierarchy(Map<String, dynamic> hierarchy) {
    final pairs = <({String key, String value})>[];
    void visit(String? parent, Map<dynamic, dynamic> tree) {
      final result = <String, dynamic>{};
      for (final MapEntry(:key, :value) in tree.entries) {
        if (value is String) {
          result[key] = value;
        } else if (value is Map) {
          visit(parent == null ? key : "$parent.$key", value);
        }
      }
    }

    visit(null, hierarchy);
    return _FlatL10nList(pairs: pairs);
  }
}

@immutable
class _FlatL10nList implements L10nCollection {
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
  L10nCollection set(String key, String? value) {
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
