import 'data.dart';

class L10nSerializationException implements Exception {
  final Exception? cause;

  const L10nSerializationException({
    this.cause,
  });
}

abstract class L10nSerializer {
  const L10nSerializer();

  L10nData parse(String content);
}
