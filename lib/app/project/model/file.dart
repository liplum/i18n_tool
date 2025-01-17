import 'package:copy_with_extension/copy_with_extension.dart';

part "file.g.dart";

@CopyWith(skipFields: true)
class FileContent {
  final String content;

  const FileContent({
    required this.content,
  });
}
