// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editing.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$L10nEditingCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nEditing(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nEditing call({
    Locale locale,
    L10nData data,
    ({L10nData data, Locale locale, List<L10nDataRow> rows})? template,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfL10nEditing.copyWith(...)`.
class _$L10nEditingCWProxyImpl implements _$L10nEditingCWProxy {
  const _$L10nEditingCWProxyImpl(this._value);

  final L10nEditing _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// L10nEditing(...).copyWith(id: 12, name: "My name")
  /// ````
  L10nEditing call({
    Object? locale = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
  }) {
    return L10nEditing(
      locale: locale == const $CopyWithPlaceholder()
          ? _value.locale
          // ignore: cast_nullable_to_non_nullable
          : locale as Locale,
      data: data == const $CopyWithPlaceholder()
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as L10nData,
      template: template == const $CopyWithPlaceholder()
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as ({L10nData data, Locale locale, List<L10nDataRow> rows})?,
    );
  }
}

extension $L10nEditingCopyWith on L10nEditing {
  /// Returns a callable class that can be used as follows: `instanceOfL10nEditing.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nEditingCWProxy get copyWith => _$L10nEditingCWProxyImpl(this);
}
