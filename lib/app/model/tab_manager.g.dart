// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_manager.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TabManagerCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// TabManager(...).copyWith(id: 12, name: "My name")
  /// ````
  TabManager call({
    Project project,
    List<L10nFileTab> openTabs,
    L10nFileTab? selectedTab,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTabManager.copyWith(...)`.
class _$TabManagerCWProxyImpl implements _$TabManagerCWProxy {
  const _$TabManagerCWProxyImpl(this._value);

  final TabManager _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// TabManager(...).copyWith(id: 12, name: "My name")
  /// ````
  TabManager call({
    Object? project = const $CopyWithPlaceholder(),
    Object? openTabs = const $CopyWithPlaceholder(),
    Object? selectedTab = const $CopyWithPlaceholder(),
  }) {
    return TabManager(
      project: project == const $CopyWithPlaceholder()
          ? _value.project
          // ignore: cast_nullable_to_non_nullable
          : project as Project,
      openTabs: openTabs == const $CopyWithPlaceholder()
          ? _value.openTabs
          // ignore: cast_nullable_to_non_nullable
          : openTabs as List<L10nFileTab>,
      selectedTab: selectedTab == const $CopyWithPlaceholder()
          ? _value.selectedTab
          // ignore: cast_nullable_to_non_nullable
          : selectedTab as L10nFileTab?,
    );
  }
}

extension $TabManagerCopyWith on TabManager {
  /// Returns a callable class that can be used as follows: `instanceOfTabManager.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$TabManagerCWProxy get copyWith => _$TabManagerCWProxyImpl(this);
}

abstract class _$L10nFileTabCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileTab(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileTab call({
    TabManager manager,
    L10nFile file,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfL10nFileTab.copyWith(...)`.
class _$L10nFileTabCWProxyImpl implements _$L10nFileTabCWProxy {
  const _$L10nFileTabCWProxyImpl(this._value);

  final L10nFileTab _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileTab(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileTab call({
    Object? manager = const $CopyWithPlaceholder(),
    Object? file = const $CopyWithPlaceholder(),
  }) {
    return L10nFileTab(
      manager: manager == const $CopyWithPlaceholder()
          ? _value.manager
          // ignore: cast_nullable_to_non_nullable
          : manager as TabManager,
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as L10nFile,
    );
  }
}

extension $L10nFileTabCopyWith on L10nFileTab {
  /// Returns a callable class that can be used as follows: `instanceOfL10nFileTab.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nFileTabCWProxy get copyWith => _$L10nFileTabCWProxyImpl(this);
}
