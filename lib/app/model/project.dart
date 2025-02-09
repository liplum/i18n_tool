import 'dart:math';
import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:i18n_tool/serialization/serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import "package:path/path.dart" as p;

part "project.g.dart";

int colorToJson(Color color) => color.value;

Color colorFromJson(int value) => Color(value);

const colorJsonKey = JsonKey(toJson: colorToJson, fromJson: colorFromJson);

Map<String, dynamic> localeToJson(Locale locale) => {
      "languageCode": locale.languageCode,
      "countryCode": locale.countryCode,
      "scriptCode": locale.scriptCode,
    };

Locale localeFromJson(Map<String, dynamic> json) => Locale.fromSubtags(
      languageCode: json["languageCode"],
      countryCode: json["countryCode"],
      scriptCode: json["scriptCode"],
    );

const localeJsonKey = JsonKey(toJson: localeToJson, fromJson: localeFromJson);

Map<String, dynamic>? localeNullableToJson(Locale? locale) => locale == null ? null : localeToJson(locale);

Locale? localeNullableFromJson(Map<String, dynamic>? json) => json == null ? null : localeFromJson(json);

const localeNullableJsonKey = JsonKey(toJson: localeNullableToJson, fromJson: localeNullableFromJson);

final _shortNameReg = RegExp(r'\s+|-|_');

@JsonEnum(alwaysCreate: true)
enum ProjectFileType {
  json(extensions: [".json"]),
  yaml(extensions: [".yaml", ".yml"]),
  properties(extensions: [".properties"]),
  ;

  final List<String> extensions;

  const ProjectFileType({
    required this.extensions,
  });

  static ProjectFileType? tryParseExtension(String ext) {
    for (final type in values) {
      if (type.extensions.contains(ext)) {
        return type;
      }
    }
    return null;
  }
}

@CopyWith(skipFields: true)
@JsonSerializable()
class ProjectType {
  final ProjectFileType fileType;
  final String filePrefix;

  /// if the project file type is capable
  final bool nestedByDot;

  const ProjectType({
    required this.fileType,
    this.nestedByDot = true,
    this.filePrefix = "",
  });

  factory ProjectType.fromJson(Map<String, dynamic> json) => _$ProjectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectTypeToJson(this);
}

@CopyWith(skipFields: true)
@JsonSerializable()
class ProjectSettings {
  final bool forceQuotedString;

  @localeNullableJsonKey
  final Locale? defaultLocale;

  const ProjectSettings({
    this.forceQuotedString = false,
    this.defaultLocale,
  });

  factory ProjectSettings.fromJson(Map<String, dynamic> json) => _$ProjectSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectSettingsToJson(this);

  SerializationSettings toSerializationSettings() {
    return SerializationSettings(
      forceQuotedString: forceQuotedString,
    );
  }
}

@immutable
@CopyWith(skipFields: true)
@JsonSerializable()
class Project {
  static const latestVersion = 1;
  final int version;
  final String uuid;
  final String name;
  @colorJsonKey
  final Color color;

  /// limit to 2
  final String shortName;
  final String rootPath;

  final ProjectType type;
  final ProjectSettings settings;

  const Project({
    this.version = Project.latestVersion,
    required this.uuid,
    required this.name,
    required this.color,
    required this.shortName,
    required this.rootPath,
    required this.type,
    this.settings = const ProjectSettings(),
  });

  factory Project.create({
    String? name,
    required String rootPath,
    required ProjectType type,
    ProjectSettings settings = const ProjectSettings(),
  }) {
    final projectName = name ?? p.basenameWithoutExtension(rootPath);
    final uuid = const Uuid().v4();
    final color = _generateColorFromSeed(uuid.hashCode);
    return Project(
      uuid: uuid,
      name: projectName,
      color: color,
      shortName: _getShortName(projectName),
      rootPath: rootPath,
      type: type,
      settings: settings,
    );
  }

  bool match(String search) {
    if (name.contains(search)) {
      return true;
    }
    return false;
  }

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

String _getShortName(String name) {
  final parts = name.split(_shortNameReg).where((it) => it.isNotEmpty).toList(growable: false);
  if (parts.length <= 1) return name.padLeft(2).substring(0, 2);
  return "${parts[0][0]}${parts[1][0]}".toUpperCase();
}

Color _generateColorFromSeed(int seed) {
  final random = Random(seed); // Create a Random object with the seed
  return Color.fromARGB(
    255, // Alpha (fully opaque)
    random.nextInt(256), // Red (0-255)
    random.nextInt(256), // Green (0-255)
    random.nextInt(256), // Blue (0-255)
  );
}
