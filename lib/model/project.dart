import 'dart:math';
import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import "package:path/path.dart" as p;

part "project.g.dart";

int colorToJson(Color color) => color.value;

Color colorFromJson(int value) => Color(value);

@CopyWith(skipFields: true)
@JsonSerializable()
class Project {
  final String uuid;
  final String name;
  @JsonKey(toJson: colorToJson, fromJson: colorFromJson)
  final Color color;

  /// limit to 2
  final String shortName;
  final String rootPath;

  const Project({
    required this.uuid,
    required this.name,
    required this.color,
    required this.shortName,
    required this.rootPath,
  });

  factory Project.create({
    String? name,
    required String rootPath,
  }) {
    final name = p.basenameWithoutExtension(rootPath);
    final uuid = const Uuid().v4();
    final color = _generateColorFromSeed(uuid.hashCode);
    return Project(
      uuid: uuid,
      name: name,
      color: color,
      shortName: name.padLeft(2).substring(0, 2),
      rootPath: rootPath,
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

Color _generateColorFromSeed(int seed) {
  final random = Random(seed); // Create a Random object with the seed
  return Color.fromARGB(
    255, // Alpha (fully opaque)
    random.nextInt(256), // Red (0-255)
    random.nextInt(256), // Green (0-255)
    random.nextInt(256), // Blue (0-255)
  );
}
