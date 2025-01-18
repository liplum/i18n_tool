// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProjectTypeCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ProjectType(...).copyWith(id: 12, name: "My name")
  /// ````
  ProjectType call({
    ProjectFileType? fileType,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProjectType.copyWith(...)`.
class _$ProjectTypeCWProxyImpl implements _$ProjectTypeCWProxy {
  const _$ProjectTypeCWProxyImpl(this._value);

  final ProjectType _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ProjectType(...).copyWith(id: 12, name: "My name")
  /// ````
  ProjectType call({
    Object? fileType = const $CopyWithPlaceholder(),
  }) {
    return ProjectType(
      fileType: fileType == const $CopyWithPlaceholder() || fileType == null
          ? _value.fileType
          // ignore: cast_nullable_to_non_nullable
          : fileType as ProjectFileType,
    );
  }
}

extension $ProjectTypeCopyWith on ProjectType {
  /// Returns a callable class that can be used as follows: `instanceOfProjectType.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$ProjectTypeCWProxy get copyWith => _$ProjectTypeCWProxyImpl(this);
}

abstract class _$ProjectCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Project(...).copyWith(id: 12, name: "My name")
  /// ````
  Project call({
    int? version,
    String? uuid,
    String? name,
    Color? color,
    String? shortName,
    String? rootPath,
    ProjectType? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProject.copyWith(...)`.
class _$ProjectCWProxyImpl implements _$ProjectCWProxy {
  const _$ProjectCWProxyImpl(this._value);

  final Project _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Project(...).copyWith(id: 12, name: "My name")
  /// ````
  Project call({
    Object? version = const $CopyWithPlaceholder(),
    Object? uuid = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? color = const $CopyWithPlaceholder(),
    Object? shortName = const $CopyWithPlaceholder(),
    Object? rootPath = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return Project(
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      uuid: uuid == const $CopyWithPlaceholder() || uuid == null
          ? _value.uuid
          // ignore: cast_nullable_to_non_nullable
          : uuid as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      color: color == const $CopyWithPlaceholder() || color == null
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as Color,
      shortName: shortName == const $CopyWithPlaceholder() || shortName == null
          ? _value.shortName
          // ignore: cast_nullable_to_non_nullable
          : shortName as String,
      rootPath: rootPath == const $CopyWithPlaceholder() || rootPath == null
          ? _value.rootPath
          // ignore: cast_nullable_to_non_nullable
          : rootPath as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as ProjectType,
    );
  }
}

extension $ProjectCopyWith on Project {
  /// Returns a callable class that can be used as follows: `instanceOfProject.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$ProjectCWProxy get copyWith => _$ProjectCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectType _$ProjectTypeFromJson(Map<String, dynamic> json) => ProjectType(
      fileType: $enumDecode(_$ProjectFileTypeEnumMap, json['fileType']),
    );

Map<String, dynamic> _$ProjectTypeToJson(ProjectType instance) => <String, dynamic>{
      'fileType': _$ProjectFileTypeEnumMap[instance.fileType]!,
    };

const _$ProjectFileTypeEnumMap = {
  ProjectFileType.json: 'json',
  ProjectFileType.yaml: 'yaml',
  ProjectFileType.properties: 'properties',
};

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      version: (json['version'] as num?)?.toInt() ?? Project.latestVersion,
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      color: colorFromJson((json['color'] as num).toInt()),
      shortName: json['shortName'] as String,
      rootPath: json['rootPath'] as String,
      type: ProjectType.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'version': instance.version,
      'uuid': instance.uuid,
      'name': instance.name,
      'color': colorToJson(instance.color),
      'shortName': instance.shortName,
      'rootPath': instance.rootPath,
      'type': instance.type,
    };
