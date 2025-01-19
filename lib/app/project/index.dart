import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Material, DataCell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/app/project/model/working_project.dart';
import 'package:i18n_tool/app/project/state/editing.dart';
import 'package:i18n_tool/app/project/state/file.dart';
import 'package:i18n_tool/app/project/state/working_project.dart';
import 'package:i18n_tool/serialization/data.dart';
import 'package:i18n_tool/widget/loading.dart';
import 'package:rettulf/rettulf.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../state/project.dart';
import 'model/editing.dart';

class ProjectIndexPage extends ConsumerStatefulWidget {
  final String uuid;

  const ProjectIndexPage({
    super.key,
    required this.uuid,
  });

  @override
  ConsumerState createState() => _ProjectIndexPageState();
}

class _ProjectIndexPageState extends ConsumerState<ProjectIndexPage> {
  late var project = ref.read($projects).firstWhere((it) => it.uuid == widget.uuid);

  @override
  Widget build(BuildContext context) {
    final workingProjectAsync = ref.watch($workingProject(project));
    final workingProject = workingProjectAsync.value;
    return OnLoading(
      loading: workingProjectAsync.isLoading,
      child: NavigationView(
        appBar: NavigationAppBar(
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: project.color.withValues(alpha: 0.8),
              child: project.shortName.text(),
            ),
            title: project.name.text(),
            subtitle: project.rootPath.text(),
          ),
        ),
        pane: NavigationPane(
          items: workingProject == null
              ? []
              : [
                  ...workingProject.l10nFiles.map((file) {
                    return PaneItemAction(
                      icon: Icon(workingProject.isTemplate(file) ? FluentIcons.file_template : FluentIcons.file_code),
                      title: file.title().text(),
                      onTap: () {
                        ref.read($workingProject(project).notifier).openTab(file);
                      },
                    );
                  }),
                  PaneItemSeparator(),
                  PaneItemAction(
                    icon: const Icon(FluentIcons.add),
                    title: const Text('Add new language'),
                    onTap: () {},
                  ),
                ],
        ),
        paneBodyBuilder: (item, child) {
          return buildEditingPanel(workingProject);
        },
      ),
    );
  }

  Widget buildEditingPanel(WorkingProject? workingProject) {
    return TabView(
      currentIndex: workingProject == null
          ? 0
          : workingProject.openTabs.indexWhere((it) => it.file.isTheSameLocale(workingProject.selectedTab?.file)),
      onChanged: workingProject == null
          ? null
          : (index) {
              ref.read($workingProject(project).notifier).selectTab(workingProject.openTabs[index].file);
            },
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      closeButtonVisibility: CloseButtonVisibilityMode.always,
      showScrollButtons: true,
      shortcutsEnabled: true,
      tabs: [
        if (workingProject != null)
          ...workingProject.openTabs.map(
            (it) => Tab(
              icon: Icon(workingProject.isTemplate(it.file) ? FluentIcons.file_template : FluentIcons.file_code),
              text: it.file.title().text(),
              body: L10nFileEditorTab(tab: it),
              onClosed: () {
                ref.read($workingProject(workingProject.project).notifier).closeTab(it.file);
              },
            ),
          ),
      ],
    );
  }
}

class L10nFileEditorTab extends ConsumerStatefulWidget {
  final L10nFileTab tab;

  const L10nFileEditorTab({
    super.key,
    required this.tab,
  });

  @override
  ConsumerState createState() => _L10nFileEditorTabState();
}

class _L10nFileEditorTabState extends ConsumerState<L10nFileEditorTab> {
  L10nEditingDataSource? dataSource;

  @override
  void dispose() {
    dataSource?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen($l10nEditing(widget.tab), (pre, next) {
      if (next is AsyncData<L10nEditing>) {
        dataSource?.dispose();
        setState(() {
          dataSource = L10nEditingDataSource(editing: next.value);
        });
      }
    });
    final source = dataSource;
    return Card(
      child: source != null ? buildEditingField(source) : const Center(child: ProgressRing()),
    );
  }

  Widget buildEditingField(L10nEditingDataSource dataSource) {
    return SfDataGrid(
      source: dataSource,
      allowEditing: true,
      navigationMode: GridNavigationMode.cell,
      selectionMode: SelectionMode.single,
      editingGestureType: EditingGestureType.tap,
      columnWidthMode: ColumnWidthMode.lastColumnFill,
      columns: <GridColumn>[
        GridColumn(
          columnName: 'key',
          width: double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Key',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'value',
          width: double.nan,
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Value',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class L10nEditingDataSource extends DataGridSource {
  L10nEditingDataSource({
    required L10nEditing editing,
  }) {
    _rows = editing.data
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'key', value: e.key),
              DataGridCell<String>(columnName: 'value', value: e.value),
            ]))
        .toList();
  }

  @override
  void dispose() {
    $editingText.dispose();
    $actions.dispose();
    super.dispose();
  }

  List<DataGridRow> _rows = [];

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return buildCell(dataGridCell.value);
    }).toList());
  }

  Widget buildCell(dynamic value) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child:value.toString().text(overflow: TextOverflow.ellipsis),
    );
  }

  /// Helps to hold the new value of all editable widgets.
  /// Based on the new value we will commit the new value into the corresponding
  /// DataGridCell on the onCellSubmit method.
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  final $editingText = TextEditingController();
  final $actions = FlyoutController();

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = _rows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    // if (column.columnName == 'key') {
    //   _rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<int>(columnName: 'id', value: newCellValue);
    //   _rows[dataRowIndex].id = newCellValue as int;
    // } else if (column.columnName == 'value') {
    //   _rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<String>(columnName: 'name', value: newCellValue);
    //   _rows[dataRowIndex].name = newCellValue.toString();
    // }
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    final cell = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName);
    // Text going to display on editable widget
    final String displayText = cell?.value?.toString() ?? '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      $actions.showFlyout(
        builder: (ctx) {
          return FlyoutContent(
            child: L10nEditingFieldFlyout(
              title: cell?.columnName.text(),
              $editingText: $editingText..text = displayText,
              onSubmit: submitCell,
            ),
          );
        },
      );
    });
    return FlyoutTarget(
      controller: $actions,
      child: buildCell(displayText),
    );
  }
}

class L10nEditingFieldFlyout extends ConsumerWidget {
  final Widget? title;
  final TextEditingController $editingText;
  final VoidCallback onSubmit;

  const L10nEditingFieldFlyout({
    super.key,
    this.title,
    required this.$editingText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return [
      // ListTile(
      //   title: title,
      // ),
      TextBox(
        autofocus: true,
        maxLines: null,
        controller: $editingText,
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          onSubmit();
        },
      ).sized(w: 480, h: 240),
      [
        Button(
          child: "Cancel".text(),
          onPressed: () {
            context.pop();
          },
        ),
        FilledButton(
          child: "Submit".text(),
          onPressed: () {
            onSubmit();
          },
        ),
      ].row(mas: MainAxisSize.min, spacing: 16),
    ].column(mas: MainAxisSize.min, spacing: 8);
  }
}
