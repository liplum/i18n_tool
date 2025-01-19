import 'package:i18n_tool/serialization/impl/json.dart';
import 'package:i18n_tool/serialization/impl/properties.dart';
import 'package:i18n_tool/serialization/impl/yaml.dart';
import 'package:i18n_tool/serialization/serializer.dart';

import '../model/project.dart';

extension ProjectEx on Project {
  L10nSerializer createParser() {
    final fileType = type.fileType;
    return switch (fileType) {
      ProjectFileType.json => JsonL10nSerializer(),
      ProjectFileType.yaml => YamlL10nSerializer(),
      ProjectFileType.properties => PropertiesL10nSerializer(),
    };
  }
}
