import 'collection.dart';

class L10nFileParseException implements Exception {
  final Exception? cause;

  const L10nFileParseException({
    this.cause,
  });
}

abstract class L10nParser {
  L10nCollection parse(String content);
}
