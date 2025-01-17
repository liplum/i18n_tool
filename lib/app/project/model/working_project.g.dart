// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_project.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WorkingProjectCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// WorkingProject(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkingProject call({
    Project? project,
    List<L10nFile>? l10nFiles,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWorkingProject.copyWith(...)`.
class _$WorkingProjectCWProxyImpl implements _$WorkingProjectCWProxy {
  const _$WorkingProjectCWProxyImpl(this._value);

  final WorkingProject _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// WorkingProject(...).copyWith(id: 12, name: "My name")
  /// ````
  WorkingProject call({
    Object? project = const $CopyWithPlaceholder(),
    Object? l10nFiles = const $CopyWithPlaceholder(),
  }) {
    return WorkingProject(
      project: project == const $CopyWithPlaceholder() || project == null
          ? _value.project
          // ignore: cast_nullable_to_non_nullable
          : project as Project,
      l10nFiles: l10nFiles == const $CopyWithPlaceholder() || l10nFiles == null
          ? _value.l10nFiles
          // ignore: cast_nullable_to_non_nullable
          : l10nFiles as List<L10nFile>,
    );
  }
}

extension $WorkingProjectCopyWith on WorkingProject {
  /// Returns a callable class that can be used as follows: `instanceOfWorkingProject.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$WorkingProjectCWProxy get copyWith => _$WorkingProjectCWProxyImpl(this);
}

abstract class _$L10nFileCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFile(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFile call({
    L10nFileType? fileType,
    String? path,
    Locale? locale,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfL10nFile.copyWith(...)`.
class _$L10nFileCWProxyImpl implements _$L10nFileCWProxy {
  const _$L10nFileCWProxyImpl(this._value);

  final L10nFile _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFile(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFile call({
    Object? fileType = const $CopyWithPlaceholder(),
    Object? path = const $CopyWithPlaceholder(),
    Object? locale = const $CopyWithPlaceholder(),
  }) {
    return L10nFile(
      fileType: fileType == const $CopyWithPlaceholder() || fileType == null
          ? _value.fileType
          // ignore: cast_nullable_to_non_nullable
          : fileType as L10nFileType,
      path: path == const $CopyWithPlaceholder() || path == null
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String,
      locale: locale == const $CopyWithPlaceholder() || locale == null
          ? _value.locale
          // ignore: cast_nullable_to_non_nullable
          : locale as Locale,
    );
  }
}

extension $L10nFileCopyWith on L10nFile {
  /// Returns a callable class that can be used as follows: `instanceOfL10nFile.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nFileCWProxy get copyWith => _$L10nFileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingProject _$WorkingProjectFromJson(Map<String, dynamic> json) => WorkingProject(
      project: Project.fromJson(json['project'] as Map<String, dynamic>),
      l10nFiles: (json['l10nFiles'] as List<dynamic>).map((e) => L10nFile.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$WorkingProjectToJson(WorkingProject instance) => <String, dynamic>{
      'project': instance.project,
      'l10nFiles': instance.l10nFiles,
    };

L10nFile _$L10nFileFromJson(Map<String, dynamic> json) => L10nFile(
      fileType: $enumDecode(_$L10nFileTypeEnumMap, json['fileType']),
      path: json['path'] as String,
      locale: localeFromJson(json['locale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$L10nFileToJson(L10nFile instance) => <String, dynamic>{
      'fileType': _$L10nFileTypeEnumMap[instance.fileType]!,
      'path': instance.path,
      'locale': localeToJson(instance.locale),
    };

const _$L10nFileTypeEnumMap = {
  L10nFileType.json: 'json',
  L10nFileType.yaml: 'yaml',
};
