import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

class L10nFileParseException implements Exception {
  final Exception? cause;

  const L10nFileParseException({
    this.cause,
  });
}

abstract class L10nParser<TResult> {
  TResult parse(String content);
}

abstract class L10nParserPlugin {}

@immutable
sealed class L10nCollection {}

@immutable
abstract class FlatList implements L10nCollection {
  String? get(String key);

  FlatList set(String key, String? value);

  factory FlatList.create({
    required List<({String key, String value})> pairs,
  }) {
    return _FlatList(pairs: pairs);
  }
}

@immutable
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
  FlatList set(String key, String? value) {
    final index = pairs.indexWhere((it) => it.key == key);
    if (index < 0) {
      if (value != null) {
        return _FlatList(pairs: [...pairs, (key: key, value: value)]);
      }
    } else {
      if (value == null) {
        return _FlatList(pairs: [...pairs]..removeAt(index));
      } else {
        return _FlatList(pairs: [...pairs]..[index] = (key: key, value: value));
      }
    }
    return this;
  }
}

abstract class FlatListL10nParser implements L10nParser<FlatList> {}

@immutable
abstract class NestedObject implements L10nCollection {
  String? getStringByKey(String key);

  String? getStringByKeyPath(String keyPath);

  NestedObject? getObjectByKey(String key);

  NestedObject? getObjectByKeyPath(String keyPath);

  NestedObject setStringByKey(String key, String? value);

  NestedObject setStringByKeyPath(String keyPath, String? value);

  NestedObject setObjectByKey(String key, NestedObject? value);

  NestedObject setObjectByKeyPath(String keyPath, NestedObject? value);

  factory NestedObject.transform(Map<String, dynamic> hierarchy) {
    NestedObject func(Map<dynamic, dynamic> tree) {
      final result = <String, dynamic>{};
      for (final MapEntry(:key, :value) in tree.entries) {
        if (value is String) {
          result[key] = value;
        } else if (value is Map) {
          final nestedObj = func(value);
          result[key] = nestedObj;
        }
      }
      return _NestedObject(tree: result);
    }

    return func(hierarchy);
  }
}

const keyPathSeparator = ".";

@immutable
class _NestedObject implements NestedObject {
  /// value could be String or NestedObject
  final Map<String, dynamic> tree;

  const _NestedObject({
    required this.tree,
  });

  dynamic _getValueByKey(String key) => tree[key];

  dynamic _getValueByKeyPath(String keyPath) {
    final keys = keyPath.split(keyPathSeparator);
    dynamic current = this;
    for (final key in keys) {
      if (current is _NestedObject) {
        current = current._getValueByKey(key);
      } else {
        return null;
      }
      if (current == null) return null;
    }
    return current;
  }

  NestedObject _setValueByKey(String key, dynamic value) {
    if (value == null) {
      tree.remove(key);
    } else {
      tree[key] = value;
    }
    throw "TODO";
  }

  NestedObject _setValueByKeyPath(String keyPath, dynamic value) {
    throw "TODO";
    final keys = keyPath.split(keyPathSeparator);
    dynamic current = this;
    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      if (i == keys.length - 1) {
        if (current is _NestedObject) {
          current._setValueByKey(key, value);
        }
      } else {
        if (current is _NestedObject) {
          final next = current._getValueByKey(key);
          if (next == null) {
            current._setValueByKey(key, <String, dynamic>{});
          }
          current = current._getValueByKey(key);
        } else {
          throw "TODO";
          // return;
        }
      }
    }
  }

  @override
  NestedObject? getObjectByKey(String key) {
    final value = _getValueByKey(key);
    if (value == null) return null;
    if (value is! Map<String, dynamic>) return null;
    return _NestedObject(tree: value);
  }

  @override
  NestedObject? getObjectByKeyPath(String keyPath) {
    final value = _getValueByKeyPath(keyPath);
    if (value == null) return null;
    if (value is! Map<String, dynamic>) return null;
    return _NestedObject(tree: value);
  }

  @override
  String? getStringByKey(String key) {
    final value = _getValueByKey(key);
    if (value is String) return value;
    return null;
  }

  @override
  String? getStringByKeyPath(String keyPath) {
    final value = _getValueByKeyPath(keyPath);
    if (value is String) return value;
    return null;
  }

  @override
  NestedObject setObjectByKey(String key, NestedObject? value) => _setValueByKey(key, value);

  @override
  NestedObject setObjectByKeyPath(String keyPath, NestedObject? value) => _setValueByKeyPath(keyPath, value);

  @override
  NestedObject setStringByKey(String key, String? value) => _setValueByKey(key, value);

  @override
  NestedObject setStringByKeyPath(String keyPath, String? value) => _setValueByKeyPath(keyPath, value);
}

abstract class NestedObjectL10nParser implements L10nParser<NestedObject> {}
