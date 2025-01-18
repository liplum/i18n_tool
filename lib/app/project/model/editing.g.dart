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
    Locale? locale,
    L10nCollection? collection,
    ({L10nCollection collection, Locale locale})? template,
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
    Object? collection = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
  }) {
    return L10nEditing(
      locale: locale == const $CopyWithPlaceholder() || locale == null
          ? _value.locale
          // ignore: cast_nullable_to_non_nullable
          : locale as Locale,
      collection: collection == const $CopyWithPlaceholder() || collection == null
          ? _value.collection
          // ignore: cast_nullable_to_non_nullable
          : collection as L10nCollection,
      template: template == const $CopyWithPlaceholder() || template == null
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as ({L10nCollection collection, Locale locale}),
    );
  }
}

extension $L10nEditingCopyWith on L10nEditing {
  /// Returns a callable class that can be used as follows: `instanceOfL10nEditing.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$L10nEditingCWProxy get copyWith => _$L10nEditingCWProxyImpl(this);
}
