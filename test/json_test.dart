import 'package:flutter_test/flutter_test.dart';
import 'package:i18n_tool/serialization/impl/json.dart';
import 'package:i18n_tool/serialization/serializer.dart';

void main() {
  group("JSON serialization", () {
    const raw = """{
  "appName": "My App",
  "author": "Liplum",
  "description": "This is a simple app",
  "index": {
    "title": "Welcome to My App",
    "content": "This is a simple app"
  },
  "about": {
    "title": "About My App",
    "content": "This is a simple app"
  }
}""";
    final settings = const SerializationSettings();
    final serializer = JsonL10nSerializer();
    test("deserialization", () {
      final data = serializer.deserialize(raw, settings);
      assert(data.get("appName") == "My App");
      assert(data.get("author") == "Liplum");
      assert(data.get("description") == "This is a simple app");
      assert(data.get("index.title") == "Welcome to My App");
      assert(data.get("index.content") == "This is a simple app");
      assert(data.get("about.title") == "About My App");
      assert(data.get("about.content") == "This is a simple app");
    });

    test("serialization", () {
      final data = serializer.deserialize(raw, settings);
      final serialized = serializer.serialize(data, settings);
      assert(serialized == raw);
    });
  });
}
