import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Proyek portofolio yang disinkronkan dengan REST API Django.
///
/// Field-nya mengikuti `ProjectSerializer` di Django: `id`, `title`,
/// `description`, `tech_stack`, `project_url`, dan `project_image_url`.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.projectUrl,
    this.projectImageUrl = '',
    this.id,
  });

  /// Membuat [Project] dari objek JSON hasil response API.
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// UUID yang dibuat oleh Django; tidak dikirim saat membuat proyek baru.
  @JsonKey(includeToJson: false)
  final String? id;

  /// Nama proyek (`title`).
  final String title;

  /// Deskripsi proyek (`description`).
  final String description;

  /// Teknologi yang digunakan (`tech_stack`).
  final String techStack;

  /// Tautan proyek (`project_url`).
  @JsonKey(defaultValue: '')
  final String projectUrl;

  /// URL gambar proyek (`project_image_url`); string kosong jika tidak ada.
  @JsonKey(defaultValue: '')
  final String projectImageUrl;

  /// Mengubah [Project] menjadi JSON untuk body request POST.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
