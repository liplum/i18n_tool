import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:i18n_tool/serialization/data.dart';
import 'package:meta/meta.dart';

part "editing.g.dart";

@immutable
@CopyWith(skipFields: true)
class L10nEditing {
  final Locale locale;
  final L10nData data;

  final ({Locale locale, L10nData data})? template;

  const L10nEditing({
    required this.locale,
    required this.data,
    required this.template,
  });
}
