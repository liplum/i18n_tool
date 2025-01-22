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

  final ({Locale locale, L10nData data, List<L10nDataRow> rows})? template;

  const L10nEditing({
    required this.locale,
    required this.data,
    required this.template,
  });

  L10nEditing.create({
    required this.locale,
    required this.data,
    ({Locale locale, L10nData data})? template,
  }) : template = template == null
            ? null
            : (
                locale: template.locale,
                data: template.data,
                rows: _buildRows(
                  data: data,
                  template: template.data,
                )
              );
}

class _RowInter {
  String? template;
  String? value;
}

List<L10nDataRow> _buildRows({
  required L10nData data,
  required L10nData template,
}) {
  final dataMap = data.toFlattenObject();
  final templateMap = template.toFlattenObject();
  final interMap = <String, _RowInter>{};
  for (final MapEntry(:key, :value) in templateMap.entries) {
    final inter = interMap[key] ??= _RowInter();
    inter.template = value;
  }
  for (final MapEntry(:key, :value) in dataMap.entries) {
    final inter = interMap[key] ??= _RowInter();
    inter.value = value;
  }
  final result = interMap.entries
      .map((entry) => L10nDataRow(key: entry.key, template: entry.value.template, value: entry.value.value))
      .toList();
  result.sort((a, b) => a.key.compareTo(b.key));
  return result;
}

class L10nDataRow {
  final String key;
  final String? template;
  final String? value;

  const L10nDataRow({
    required this.key,
    required this.template,
    required this.value,
  });
}
