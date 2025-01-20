import 'dart:ui';

import 'package:locale_names/locale_names.dart';

extension LocaleEx on Locale {
  String l10n() => "$defaultDisplayLanguageScript (${toLanguageTag()})";
}
