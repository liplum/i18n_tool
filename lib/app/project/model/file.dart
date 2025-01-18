import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:meta/meta.dart';

part "file.g.dart";

@immutable
@CopyWith(skipFields: true)
class FileContent {
  final String content;

  const FileContent({
    required this.content,
  });
}
