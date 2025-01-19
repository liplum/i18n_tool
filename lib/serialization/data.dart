import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

const keyPathSeparator = ".";

typedef L10nPair = ({String key, String value});

@immutable
abstract class L10nData implements Iterable<L10nPair> {
  int get size;

  L10nPair operator [](int index);

  String? get(String key);

  L10nData set(String key, String? value);

  Map<String, dynamic> toNestedMap();

  factory L10nData.create({
    required List<({String key, String value})> pairs,
  }) {
    return _FlatL10nList(pairs: pairs);
  }

  factory L10nData.fromHierarchy(Map hierarchy) {
    final pairs = <({String key, String value})>[];
    void visit(String? parent, Map tree) {
      for (final MapEntry(:key, :value) in tree.entries) {
        final curKey = parent == null ? "$key" : "$parent$keyPathSeparator$key";
        if (value is String) {
          pairs.add((key: curKey, value: value));
        } else if (value is Map) {
          visit(curKey, value);
        }
      }
    }

    visit(null, hierarchy);
    return _FlatL10nList(pairs: pairs);
  }
}

@immutable
class _FlatL10nList with Iterable<L10nPair> implements L10nData {
  final List<L10nPair> pairs;

  const _FlatL10nList({
    required this.pairs,
  });

  @override
  Iterator<L10nPair> get iterator => pairs.iterator;

  @override
  ({String key, String value}) operator [](int index) => pairs[index];

  @override
  int get size => pairs.length;

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

  @override
  Map<String, dynamic> toNestedMap() {
    final result = <String, dynamic>{};
    for (final (:key, :value) in this) {
      final keys = key.split(keyPathSeparator);
      Map<String, dynamic> cur = result;
      for (final k in keys.sublist(0, keys.length - 1)) {
        if (!cur.containsKey(k)) {
          cur[k] = <String, dynamic>{};
        }
        cur = cur[k] as Map<String, dynamic>;
      }
      cur[keys.last] = value;
    }
    return result;
  }
}
