import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:i18n_tool/serialization/collection.dart';
import 'package:meta/meta.dart';

part "editing.g.dart";

@immutable
@CopyWith(skipFields: true)
class L10nEditing {
  final Locale locale;
  final L10nCollection collection;

  final ({Locale locale, L10nCollection collection}) template;

  const L10nEditing({
    required this.locale,
    required this.collection,
    required this.template,
  });
}
