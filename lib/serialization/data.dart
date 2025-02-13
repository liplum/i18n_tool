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

  Map<String, dynamic> toNestedObject();

  Map<String, String> toFlattenObject();

  factory L10nData.create({
    required List<L10nPair> pairs,
  }) {
    return _FlatL10nDataList(pairs: pairs);
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
    return _FlatL10nDataList(pairs: pairs);
  }
}

@immutable
class _FlatL10nDataList with Iterable<L10nPair> implements L10nData {
  final List<L10nPair> pairs;

  const _FlatL10nDataList({
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
        return _FlatL10nDataList(pairs: [...pairs, (key: key, value: value)]);
      }
    } else {
      if (value == null) {
        return _FlatL10nDataList(pairs: [...pairs]..removeAt(index));
      } else {
        return _FlatL10nDataList(pairs: [...pairs]..[index] = (key: key, value: value));
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toNestedObject() {
    final result = <String, dynamic>{};
    final sortedResult = toList().sortedBy((it) => it.key);
    for (final (:key, :value) in sortedResult) {
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

  @override
  Map<String, String> toFlattenObject() {
    final sortedResult = toList().sortedBy((it) => it.key);
    final result = Map.fromEntries(sortedResult.map((it) => MapEntry(it.key, it.value)));
    return result;
  }
}
