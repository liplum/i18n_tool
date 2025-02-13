import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:i18n_tool/serialization/data.dart';

import 'working_project.dart';

part "editing.g.dart";

@CopyWith(skipFields: true)
class L10nFileAndData {
  final L10nFile file;
  final L10nData data;

  const L10nFileAndData({
    required this.file,
    required this.data,
  });
}

@CopyWith(skipFields: true)
class L10nFileTabState {
  final L10nFileAndData current;
  final L10nFileAndData? template;

  const L10nFileTabState({
    required this.current,
    required this.template,
  });

  L10nDataRows buildRows() {
    return _buildRows(
      current: current.data,
      template: template?.data,
    );
  }
}

class _RowInter {
  String? template;
  String? value;
}

L10nDataRows _buildRows({
  required L10nData current,
  required L10nData? template,
}) {
  final currentMap = current.toFlattenObject();
  final templateMap = template?.toFlattenObject();
  final interMap = <String, _RowInter>{};
  if (templateMap != null) {
    for (final MapEntry(:key, :value) in templateMap.entries) {
      final inter = interMap[key] ??= _RowInter();
      inter.template = value;
    }
  }
  for (final MapEntry(:key, :value) in currentMap.entries) {
    final inter = interMap[key] ??= _RowInter();
    inter.value = value;
  }
  final result = interMap.entries
      .map((entry) => L10nDataRow(key: entry.key, template: entry.value.template, value: entry.value.value))
      .toList();
  result.sort((a, b) => a.key.compareTo(b.key));
  return L10nDataRows(
    rows: result,
    hasTemplate: template != null,
  );
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

class L10nDataRows {
  final List<L10nDataRow> rows;
  final bool hasTemplate;

  const L10nDataRows({
    required this.rows,
    required this.hasTemplate,
  });
}
