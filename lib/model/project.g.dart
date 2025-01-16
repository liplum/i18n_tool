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
    Object? rootPath = const $CopyWithPlaceholder(),
  }) {
    return Project(
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
      rootPath: json['rootPath'] as String,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'rootPath': instance.rootPath,
    };
