import 'dart:convert';

import '../data.dart';
import '../serializer.dart';

class JsonL10nSerializer implements L10nSerializer {
  const JsonL10nSerializer();

  @override
  L10nData deserialize(String content) {
    final json = jsonDecode(content);
    if (json is! Map) throw L10nSerializationException();
    return L10nData.fromHierarchy(json);
  }

  @override
  String serialize(L10nData data) {
    final object = data.toNestedObject();
    final encoder = JsonEncoder.withIndent(" " * 2);
    final encoded = encoder.convert(object);
    return encoded;
  }
}
