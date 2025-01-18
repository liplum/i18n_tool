import 'collection.dart';

class L10nFileParseException implements Exception {
  final Exception? cause;

  const L10nFileParseException({
    this.cause,
  });
}

abstract class L10nParser {
  const L10nParser();

  L10nData parse(String content);
}
