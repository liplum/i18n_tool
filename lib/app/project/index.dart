import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/app/model/tab_manager.dart';
import 'package:i18n_tool/app/project/model/file.dart';
import 'package:i18n_tool/app/project/model/working_project.dart';
import 'package:i18n_tool/app/project/state/editing.dart';
import 'package:i18n_tool/app/project/state/working_project.dart';
import 'package:i18n_tool/app/utils/locale.dart';
import 'package:i18n_tool/app/utils/project.dart';
import 'package:i18n_tool/serialization/data.dart';
import 'package:i18n_tool/widget/app_menu.dart';
import 'package:i18n_tool/widget/dialog.dart';
import 'package:i18n_tool/widget/fluent_ui.dart';
import 'package:i18n_tool/widget/loading.dart';
import 'package:locale_names/locale_names.dart';
import 'package:rettulf/rettulf.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../menu_bar.dart';
import '../state/project.dart';
import 'model/editing.dart';
import 'state/tab_manager.dart';

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
  late final appMenuController = buildAppMenuController(context);
  late var project = ref.read($projects).firstWhere((it) => it.uuid == widget.uuid);

  @override
  void dispose() {
    appMenuController.dispose();
    super.dispose();
  }

  void updateMenus({
    L10nFileTab? selectedTab,
  }) {
    appMenuController.updateMenus([
      AppMenuCategory(
        label: "File",
        items: [
          AppMenuItem(
            label: "New Language File",
            onPressed: addNewLanguage,
          ),
          // AppMenuItem(
          //   label: "Save",
          //   shortcut: CharacterActivator("s", meta: true),
          //   onPressed: selectedTab == null ? null : ()async  {
          //     final serialized =
          //     project.createSerializer().serialize(data, project.settings.toSerializationSettings());
          //     final fi = File(widget.tab.file.path);
          //     await fi.writeAsString(serialized);
          //   },
          // ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final workingProjectAsync = ref.watch($workingProject(project));
    final workingProject = workingProjectAsync.value;
    final tabManager = ref.watch($tabManager(project));
    ref.listen($tabManager(project).select((it) => it.selectedTab), (pre, next) {
      updateMenus(
        selectedTab: next,
      );
    });
    return AppMenu(
      controller: appMenuController,
      child: AppMenuPage(
        key: Key("Project/${project.uuid}"),
        onRebuild: updateMenus,
        child: OnLoading(
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
                contentPadding: EdgeInsetsDirectional.only(
                  end: 12.0,
                  bottom: 6.0,
                ),
              ),
            ),
            pane: NavigationPane(
              items: workingProject == null
                  ? []
                  : [
                      ...workingProject.l10nFiles
                          // keep the template at the top
                          .sortedBy((it) => workingProject.isTemplate(it) ? "" : it.locale.nativeDisplayLanguageScript)
                          .map((file) {
                        return PaneItemAction(
                          icon:
                              Icon(workingProject.isTemplate(file) ? FluentIcons.file_template : FluentIcons.file_code),
                          title: file.title().text(),
                          onTap: () {
                            ref.read($tabManager(project).notifier).openTab(file);
                          },
                          trailing: IconButton(
                            icon: Icon(FluentIcons.delete, size: 12),
                            onPressed: () async {
                              await context.showDialogRequest(
                                title: 'Delete File?',
                                desc:
                                    """Confirm to delete "${file.locale.defaultDisplayLanguageScript}" file? It's not recoverable.""",
                                primary: "Delete",
                                secondary: "Cancel",
                              );
                            },
                          ),
                        );
                      }),
                    ],
            ),
            paneBodyBuilder: (item, child) {
              return buildEditingPanel(
                workingProject: workingProject,
                manager: tabManager,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> addNewLanguage() async {
    await showDialog(
      context: context,
      builder: (ctx) => const CreateLanguageForm(),
    );
  }

  Widget buildEditingPanel({
    WorkingProject? workingProject,
    TabManager? manager,
  }) {
    return TabView(
      currentIndex:
          manager == null ? 0 : manager.openTabs.indexWhere((it) => it.file.isTheSameLocale(manager.selectedTab?.file)),
      onChanged: manager == null
          ? null
          : (index) {
              ref.read($tabManager(project).notifier).selectTab(manager.openTabs[index].file);
            },
      // TODO: support reordering
      // onReorder: (oldIndex, newIndex) {
      //   ref.read($workingProject(project).notifier).recordTab(oldIndex,newIndex);
      // },
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      closeButtonVisibility: CloseButtonVisibilityMode.always,
      showScrollButtons: true,
      shortcutsEnabled: true,
      tabs: [
        if (manager != null && workingProject != null)
          ...manager.openTabs.map(
            (it) => Tab(
              icon: Icon(workingProject.isTemplate(it.file) ? FluentIcons.file_template : FluentIcons.file_code),
              text: it.file.title().text(),
              body: L10nFileEditorTab(
                workingProject: workingProject,
                tab: it,
              ),
              onClosed: () {
                ref.read($tabManager(manager.project).notifier).closeTab(it.file);
              },
            ),
          ),
      ],
    );
  }
}

class CreateLanguageForm extends ConsumerStatefulWidget {
  const CreateLanguageForm({super.key});

  @override
  ConsumerState createState() => _CreateLanguageFormState();
}

class _CreateLanguageFormState extends ConsumerState<CreateLanguageForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FluentTheme.of(context).micaBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          title: "Add a language target".text(),
        ),
        bottomBar: [
          FilledButton(
            onPressed: () {},
            child: "Add Language".text(),
          ),
        ].row(maa: MainAxisAlignment.end).padAll(8),
        content: buildBody().padSymmetric(h: 32),
      ),
    );
  }

  Widget buildBody() {
    return [
      "".text(),
    ].column(spacing: 8);
  }
}

class L10nFileEditorTab extends ConsumerStatefulWidget {
  final WorkingProject workingProject;
  final L10nFileTab tab;

  const L10nFileEditorTab({
    super.key,
    required this.workingProject,
    required this.tab,
  });

  @override
  ConsumerState createState() => _L10nFileEditorTabState();
}

class _L10nFileEditorTabState extends ConsumerState<L10nFileEditorTab> with AutomaticKeepAliveClientMixin {
  _L10nEditingDataSource? dataSource;
  final controller = DataGridController();
  var loading = false;

  @override
  void dispose() {
    dataSource?.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tab = widget.tab;
    final templateL10nFile = widget.workingProject.templateL10nFile;
    final templateFile =
        templateL10nFile != null && templateL10nFile.locale != tab.file.locale ? templateL10nFile : null;
    ref.listen(
        $l10nFileTab((
          project: widget.workingProject.project,
          current: widget.tab.file,
          template: templateFile,
        )), (pre, next) {
      if (next is AsyncData<L10nFileTabState>) {
        onFileChangedOutside(next.value);
      }
    });

    final source = dataSource;
    return OnLoading(
      loading: loading,
      child: [
        buildCommandBar().sized(h: 32).padAll(4),
        (source != null ? buildEditingField(source) : ProgressRing().center()).expanded(),
      ].column().padOnly(l: 16, r: 16),
    );
  }

  void updateDataSource(L10nFileTabState state) {
    dataSource?.dispose();
    setState(() {
      dataSource = _L10nEditingDataSource(
        controller: controller,
        state: state,
      );
    });
  }

  var showingFileChangesDialog = false;

  Future<void> onFileChangedOutside(L10nFileTabState state) async {
    if (!context.mounted) return;
    if (dataSource == null) {
      updateDataSource(state);
      return;
    }
    if (!showingFileChangesDialog) {
      showingFileChangesDialog = true;
      await showFileChangesDialog(state);
      showingFileChangesDialog = false;
    }
  }

  Future<void> showFileChangesDialog(L10nFileTabState state) async {
    final memoryContent = await context.showDialogRequest(
      title: "File Changed",
      desc:
          'The local file "${state.current.file.locale.defaultDisplayLanguageScript}" was changed, do you want to reload from the file system or memory content?',
      primary: "Keep Memory",
      secondary: "Reload from File",
    );
    if (memoryContent == null) return;
    if (!memoryContent) {
      updateDataSource(state);
    }
  }

  L10nData loadData(FileContent fileContent) {
    final project = widget.workingProject.project;
    final data = project.createSerializer().deserialize(
          fileContent.content,
          project.settings.toSerializationSettings(),
        );
    return data;
  }

  Widget buildCommandBar() {
    final dataSource = this.dataSource;
    return CommandBar(
      primaryItems: [
        CommandBarItemWithTooltip(
          tooltip: "Add",
          icon: Icon(FluentIcons.add),
          onPressed: dataSource == null ? null : () async {},
        ),
        CommandBarItemWithTooltip(
          tooltip: "Remove",
          icon: Icon(FluentIcons.remove),
          onPressed: dataSource == null
              ? null
              : () async {
                  final selectedRow = controller.selectedRow;
                  if (selectedRow == null) return;
                  final cells = selectedRow.getCells();
                  final key = cells.firstWhereOrNull((it) => it.columnName == "key")?.value as String?;
                  if (key == null) return;
                  dataSource.removeRow(key);
                },
        ),
        CommandBarSeparator(),
        CommandBarButton(
          icon: Icon(FluentIcons.save),
          label: "Save".text(),
          onPressed: dataSource == null
              ? null
              : () async {
                  setState(() {
                    loading = true;
                  });
                  final data = dataSource.buildL10nData();
                  final project = widget.tab.manager.project;
                  final serialized =
                      project.createSerializer().serialize(data, project.settings.toSerializationSettings());
                  final fi = File(widget.tab.file.path);
                  await fi.writeAsString(serialized);
                  setState(() {
                    loading = false;
                  });
                },
        ),
      ],
    );
  }

  Widget buildEditingField(_L10nEditingDataSource dataSource) {
    final template = dataSource.state.template;
    return SfDataGridTheme(
      data: SfDataGridThemeData(
        gridLineColor: FluentTheme.of(context).inactiveColor.withValues(alpha: 0.2),
        gridLineStrokeWidth: 1.0,
      ),
      child: SfDataGrid(
        controller: controller,
        source: dataSource,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
        allowEditing: true,
        allowSorting: true,
        navigationMode: GridNavigationMode.cell,
        selectionMode: SelectionMode.single,
        editingGestureType: EditingGestureType.tap,
        columnWidthMode: ColumnWidthMode.fill,
        onQueryRowHeight: (details) {
          if (details.rowIndex == 0) return 42;
          return details.getIntrinsicRowHeight(details.rowIndex) * 0.8;
        },
        columns: <GridColumn>[
          GridColumn(
            columnName: 'index',
            allowEditing: false,
            width: 64,
            visible: false,
            label: "#".text(overflow: TextOverflow.ellipsis).padAll(8).align(at: Alignment.centerLeft),
          ),
          GridColumn(
            columnName: 'key',
            width: double.nan,
            label: "Key".text(overflow: TextOverflow.ellipsis).padAll(8).align(at: Alignment.centerLeft),
          ),
          if (template != null)
            GridColumn(
              columnName: 'template',
              width: double.nan,
              allowEditing: false,
              label: template.file.locale
                  .l10n()
                  .text(overflow: TextOverflow.ellipsis)
                  .padAll(8)
                  .align(at: Alignment.centerLeft),
            ),
          GridColumn(
            columnName: 'value',
            width: double.nan,
            label: dataSource.state.current.file.locale
                .l10n()
                .text(overflow: TextOverflow.ellipsis)
                .padAll(8)
                .align(at: Alignment.centerLeft),
          ),
        ],
      ),
    );
  }
}

class _L10nCell extends StatelessWidget {
  final int index;
  final String columnName;
  final dynamic value;

  const _L10nCell({
    required this.index,
    required this.columnName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (columnName == "index") {
      return "${index + 1}".text().align(at: Alignment.topLeft).padAll(8);
    } else if (value == null) {
      return Opacity(
        opacity: 0.8,
        child: "<Missing>".text(
            style: TextStyle(
          fontStyle: FontStyle.italic,
        )),
      ).align(at: Alignment.topLeft).padAll(8);
    } else {
      final text = value.toString();
      return Tooltip(
        message: text,
        style: TooltipThemeData(
          maxWidth: 520,
        ),
        child: text.text().align(at: Alignment.topLeft).padAll(8),
      );
    }
  }
}

class _L10nEditingDataSource extends DataGridSource {
  final L10nFileTabState state;
  final DataGridController controller;
  var _rows = <DataGridRow>[];

  _L10nEditingDataSource({
    required this.controller,
    required this.state,
  }) {
    final rows = state.buildRows();
    if (rows.hasTemplate) {
      _rows = rows.rows
          .mapIndexed((i, row) => DataGridRow(cells: [
                DataGridCell<int>(
                  columnName: 'index',
                  value: i,
                ),
                DataGridCell<String>(
                  columnName: 'key',
                  value: row.key,
                ),
                DataGridCell<String>(
                  columnName: 'template',
                  value: row.template,
                ),
                DataGridCell<String>(
                  columnName: 'value',
                  value: row.value,
                ),
              ]))
          .toList();
    } else {
      _rows = rows.rows
          .mapIndexed((i, row) => DataGridRow(cells: [
                DataGridCell<int>(
                  columnName: 'index',
                  value: i,
                ),
                DataGridCell<String>(
                  columnName: 'key',
                  value: row.key,
                ),
                DataGridCell<String>(
                  columnName: 'value',
                  value: row.value,
                ),
              ]))
          .toList();
    }
  }

  @override
  void dispose() {
    $editingText.dispose();
    super.dispose();
  }

  @override
  List<DataGridRow> get rows => _rows;

  L10nData buildL10nData() {
    final pairs = <L10nPair>[];
    for (final cellsInRow in _rows.map((row) => row.getCells())) {
      final key = cellsInRow.firstWhereOrNull((cell) => cell.columnName == "key")?.value;
      final value = cellsInRow.firstWhereOrNull((cell) => cell.columnName == "value")?.value;
      if (key != null && value != null) {
        pairs.add((key: key, value: value));
      }
    }
    return L10nData.create(pairs: pairs);
  }

  void addRow() {}

  void removeRow(String key) {
    final rowIndex =
        _rows.indexWhere((it) => it.getCells().firstWhereOrNull((it) => it.columnName == "key")?.value == key);
    if (rowIndex < 0) return;
    _rows.removeAt(rowIndex);
    notifyListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final cells = row.getCells();
    final indexCell = cells.firstWhere((it) => it.columnName == "index");
    final index = indexCell.value as int? ?? 0;
    return DataGridRowAdapter(
      cells: cells
          .mapIndexed((i, cell) => Builder(
                builder: (context) {
                  return _L10nCell(
                    index: index,
                    columnName: cell.columnName,
                    value: cell.value,
                  );
                },
              ))
          .toList(growable: false),
    );
  }

  /// Helps to hold the new value of all editable widgets.
  /// Based on the new value we will commit the new value into the corresponding
  /// DataGridCell on the onCellSubmit method.
  String? newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  final $editingText = TextEditingController();

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final cells = dataGridRow.getCells();
    final cell = cells.firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName);
    final oldValue = cell?.value;

    final newCellValue = $editingText.text;
    if (oldValue == newCellValue) return;
    debugPrint("Edited: $newCellValue");

    if (column.columnName == 'key') {
      cells[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: 'key', value: newCellValue);
    } else if (column.columnName == 'value') {
      cells[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: 'value', value: newCellValue);
    }
  }

  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    final cells = dataGridRow.getCells();
    final editingCell =
        cells.firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName);
    final keyCell = cells.firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == "key");
    // Text going to display on editable widget
    final initialText = editingCell?.value?.toString() ?? "";

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    return L10nEditingFieldFlyout(
      title: keyCell?.value.toString().text(),
      $editingText: $editingText..text = initialText,
      onSubmit: () {
        newCellValue = $editingText.text;
        submitCell();
      },
      onCancel: () {
        $editingText.text = initialText;
        newCellValue = initialText;
      },
    );
  }
}

class L10nEditingFieldFlyout extends ConsumerStatefulWidget {
  final Widget? title;
  final TextEditingController $editingText;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const L10nEditingFieldFlyout({
    super.key,
    this.title,
    required this.$editingText,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  ConsumerState createState() => _L10nEditingFieldFlyoutState();
}

class _L10nEditingFieldFlyoutState extends ConsumerState<L10nEditingFieldFlyout> {
  final $actions = FlyoutController();

  @override
  void dispose() {
    $actions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: $actions,
      child: [
        TextBox(
          autofocus: true,
          maxLines: null,
          textAlignVertical: TextAlignVertical.top,
          controller: widget.$editingText,
          onSubmitted: (_) {
            widget.onSubmit();
          },
        ).expanded(),
        IconButton(
          icon: Icon(FluentIcons.expand_all),
          onPressed: openFlyoutEditing,
        ),
      ].row(),
    ).padAll(4);
  }

  Future<void> openFlyoutEditing() async {
    await $actions.showFlyout(
      builder: (ctx) {
        return FlyoutContent(
          child: buildFlyoutContent(ctx),
        );
      },
    );
  }

  Widget buildFlyoutContent(BuildContext context) {
    return [
      ListTile(
        title: widget.title,
      ),
      TextBox(
        autofocus: true,
        maxLines: null,
        minLines: 10,
        controller: widget.$editingText,
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          widget.onSubmit();
        },
      ),
      [
        Button(
          child: "Cancel".text(),
          onPressed: () {
            context.pop();
            widget.onCancel();
          },
        ).expanded(),
        FilledButton(
          child: "Submit".text(),
          onPressed: () {
            context.pop();
            widget.onSubmit();
          },
        ).expanded(),
      ].row(spacing: 32),
    ].column(mas: MainAxisSize.min, spacing: 8).constrained(maxW: 480);
  }
}
