// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileContentCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// FileContent(...).copyWith(id: 12, name: "My name")
  /// ````
  FileContent call({
    String? content,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileContent.copyWith(...)`.
class _$FileContentCWProxyImpl implements _$FileContentCWProxy {
  const _$FileContentCWProxyImpl(this._value);

  final FileContent _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// FileContent(...).copyWith(id: 12, name: "My name")
  /// ````
  FileContent call({
    Object? content = const $CopyWithPlaceholder(),
  }) {
    return FileContent(
      content: content == const $CopyWithPlaceholder() || content == null
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String,
    );
  }
}

extension $FileContentCopyWith on FileContent {
  /// Returns a callable class that can be used as follows: `instanceOfFileContent.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$FileContentCWProxy get copyWith => _$FileContentCWProxyImpl(this);
}
