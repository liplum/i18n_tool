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
    String? name,
    String? shortName,
    String? rootPath,
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
    Object? name = const $CopyWithPlaceholder(),
    Object? shortName = const $CopyWithPlaceholder(),
    Object? rootPath = const $CopyWithPlaceholder(),
  }) {
    return Project(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      shortName: shortName == const $CopyWithPlaceholder() || shortName == null
          ? _value.shortName
          // ignore: cast_nullable_to_non_nullable
          : shortName as String,
      rootPath: rootPath == const $CopyWithPlaceholder() || rootPath == null
          ? _value.rootPath
          // ignore: cast_nullable_to_non_nullable
          : rootPath as String,
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
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      rootPath: json['rootPath'] as String,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'shortName': instance.shortName,
      'rootPath': instance.rootPath,
    };
