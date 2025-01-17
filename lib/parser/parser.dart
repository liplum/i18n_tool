class L10nFileParseException implements Exception {
  final Exception? cause;

  const L10nFileParseException({
    this.cause,
  });
}

abstract class L10nParser<TResult> {
  Future<TResult> parse(String content);
}

abstract class L10nParserPlugin {}
