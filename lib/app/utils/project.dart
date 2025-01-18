import 'package:i18n_tool/serialization/impl/json.dart';
import 'package:i18n_tool/serialization/impl/properties.dart';
import 'package:i18n_tool/serialization/impl/yaml.dart';
import 'package:i18n_tool/serialization/parser.dart';

import '../model/project.dart';

extension ProjectEx on Project {
  L10nParser createParser() {
    final fileType = type.fileType;
    return switch (fileType) {
      ProjectFileType.json => JsonL10nParser(),
      ProjectFileType.yaml => YamlL10nParser(),
      ProjectFileType.properties => PropertiesL10nParser(),
    };
  }
}
