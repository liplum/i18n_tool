import 'dart:convert';

import 'package:i18n_tool/parser/parser.dart';
import 'package:yaml/yaml.dart';

abstract class NestedObject {
  const NestedObject();

  String? getStringByKey(String key);

  String? getStringByKeyPath(String keyPath);

  NestedObject? getObjectByKey(String key);

  NestedObject? getObjectByKeyPath(String keyPath);

  void setStringByKey(String key, String? value);

  void setStringByKeyPath(String keyPath, String? value);

  void setObjectByKey(String key, NestedObject? value);

  void setObjectByKeyPath(String keyPath, NestedObject? value);

  static NestedObject parse(
    Map<String, dynamic> hierarchy) {
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

const keyPathSeparator  = ".";

class _NestedObject implements NestedObject {
  /// value could be String or NestedObject
  final Map<String, dynamic> tree;

  _NestedObject({
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

  void _setValueByKey(String key, dynamic value) {
    if (value == null) {
      tree.remove(key);
    } else {
      tree[key] = value;
    }
  }

  void _setValueByKeyPath(String keyPath, dynamic value) {
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
          return;
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
  void setObjectByKey(String key, NestedObject? value) => _setValueByKey(key, value);

  @override
  void setObjectByKeyPath(String keyPath, NestedObject? value) => _setValueByKeyPath(keyPath, value);

  @override
  void setStringByKey(String key, String? value) => _setValueByKey(key, value);

  @override
  void setStringByKeyPath(String keyPath, String? value) => _setValueByKeyPath(keyPath, value);
}

abstract class NestedObjectL10nParser implements L10nParser<NestedObject> {}

class JsonL10nParser implements NestedObjectL10nParser {
  @override
  Future<NestedObject> parse(String content) async {
    final json = jsonDecode(content);
    if (json is! Map) throw L10nFileParseException();
    return NestedObject.parse(json.cast<String, dynamic>());
  }
}

class YamlL10nParser implements NestedObjectL10nParser {
  @override
  Future<NestedObject> parse(String content) async {
    final yaml = loadYaml(content);
    if (yaml is! Map) throw L10nFileParseException();
    return NestedObject.parse(yaml.cast<String, dynamic>());
  }
}
