// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editing.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$L10nFileAndDataCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileAndData(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileAndData call({
    L10nFile file,
    L10nData data,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfL10nFileAndData.copyWith(...)`.
class _$L10nFileAndDataCWProxyImpl implements _$L10nFileAndDataCWProxy {
  const _$L10nFileAndDataCWProxyImpl(this._value);

  final L10nFileAndData _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileAndData(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileAndData call({
    Object? file = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
  }) {
    return L10nFileAndData(
      file: file == const $CopyWithPlaceholder()
          ? _value.file
          // ignore: cast_nullable_to_non_nullable
          : file as L10nFile,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as L10nData,
    );
  }
}

extension $L10nFileAndDataCopyWith on L10nFileAndData {
  /// Returns a callable class that can be used as follows: `instanceOfL10nFileAndData.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nFileAndDataCWProxy get copyWith => _$L10nFileAndDataCWProxyImpl(this);
}

abstract class _$L10nFileTabStateCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileTabState(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileTabState call({
    L10nFileAndData current,
    L10nFileAndData? template,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfL10nFileTabState.copyWith(...)`.
class _$L10nFileTabStateCWProxyImpl implements _$L10nFileTabStateCWProxy {
  const _$L10nFileTabStateCWProxyImpl(this._value);

  final L10nFileTabState _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nFileTabState(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nFileTabState call({
    Object? current = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
  }) {
    return L10nFileTabState(
      current: current == const $CopyWithPlaceholder()
          ? _value.current
          // ignore: cast_nullable_to_non_nullable
          : current as L10nFileAndData,
      template: template == const $CopyWithPlaceholder()
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as L10nFileAndData?,
    );
  }
}

extension $L10nFileTabStateCopyWith on L10nFileTabState {
  /// Returns a callable class that can be used as follows: `instanceOfL10nFileTabState.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nFileTabStateCWProxy get copyWith => _$L10nFileTabStateCWProxyImpl(this);
}
