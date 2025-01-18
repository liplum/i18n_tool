// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProjectCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Project(...).copyWith(id: 12, name: "My name")
  /// ````
  Project call({
    String? uuid,
    String? name,
    Color? color,
    String? shortName,
    String? rootPath,
    L10nFileType? fileType,
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
    Object? uuid = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? color = const $CopyWithPlaceholder(),
    Object? shortName = const $CopyWithPlaceholder(),
    Object? rootPath = const $CopyWithPlaceholder(),
    Object? fileType = const $CopyWithPlaceholder(),
  }) {
    return Project(
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
      fileType: fileType == const $CopyWithPlaceholder() || fileType == null
          ? _value.fileType
          // ignore: cast_nullable_to_non_nullable
          : fileType as L10nFileType,
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

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      color: colorFromJson((json['color'] as num).toInt()),
      shortName: json['shortName'] as String,
      rootPath: json['rootPath'] as String,
      fileType: $enumDecode(_$L10nFileTypeEnumMap, json['fileType']),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'color': colorToJson(instance.color),
      'shortName': instance.shortName,
      'rootPath': instance.rootPath,
      'fileType': _$L10nFileTypeEnumMap[instance.fileType]!,
    };

const _$L10nFileTypeEnumMap = {
  L10nFileType.json: 'json',
  L10nFileType.yaml: 'yaml',
  L10nFileType.properties: 'properties',
};

const _$ProjectTypeEnumMap = {
  ProjectType.nestedObject: 'nestedObject',
};
