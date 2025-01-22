import 'data.dart';

class L10nSerializationException implements Exception {
  final Exception? cause;

  const L10nSerializationException({
    this.cause,
  });
}

class SerializationSettings {
  final bool forceQuotedString;

  const SerializationSettings({
    this.forceQuotedString = false,
  });
}

abstract class L10nSerializer {
  const L10nSerializer();

  L10nData deserialize(String content, SerializationSettings settings);

  String serialize(L10nData data, SerializationSettings settings);
}
