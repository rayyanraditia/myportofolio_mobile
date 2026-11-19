/// Jenjang pendidikan yang tersedia, mengikuti `EDUCATION_CHOICES` pada
/// model `Education` di proyek Django.
///
/// [value] disamakan persis dengan nilai yang disimpan Django (termasuk
/// ejaan `juniour`) agar data dari aplikasi ini nantinya dapat dikirim ke
/// REST API tanpa konversi. [label] adalah teks yang ditampilkan ke pengguna.
enum EducationLevel {
  juniorHighSchool('juniour high school', 'Junior High School'),
  seniorHighSchool('senior high school', 'Senior High School'),
  university('university', 'University');

  const EducationLevel(this.value, this.label);

  /// Nilai yang disimpan di basis data Django.
  final String value;

  /// Nama jenjang yang ditampilkan di antarmuka.
  final String label;
}

/// Data satu riwayat pendidikan yang diisi melalui formulir Edukasi.
///
/// Field-nya mengikuti model `Education` di Django: `title`, `description`,
/// `category`, `thumbnail`, `started_at`, dan `ended_at`.
class Education {
  /// Nama institusi pendidikan (`title` di Django, maksimal 255 karakter).
  final String institution;

  /// Deskripsi singkat pengalaman pendidikan.
  final String description;

  /// Jenjang pendidikan (`category` di Django).
  final EducationLevel level;

  /// URL logo institusi (`thumbnail` di Django); `null` jika tidak diisi.
  final String? logoUrl;

  /// Tanggal mulai pendidikan.
  final DateTime startedAt;

  /// Tanggal selesai pendidikan; `null` berarti masih berlangsung.
  final DateTime? endedAt;

  const Education({
    required this.institution,
    required this.description,
    required this.level,
    required this.startedAt,
    this.logoUrl,
    this.endedAt,
  });

  /// Sama seperti properti `is_ongoing` pada model Django.
  bool get isOngoing => endedAt == null;
}
