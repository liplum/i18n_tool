import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part "project.g.dart";

@CopyWith(skipFields: true)
@JsonSerializable()
class Project {
  final String name;

  /// limit to 2
  final String shortName;
  final String rootPath;

  const Project({
    required this.name,
    required this.shortName,
    required this.rootPath,
  });

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
