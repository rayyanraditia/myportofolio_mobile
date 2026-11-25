/// Kumpulan fungsi validasi formulir yang dapat dipakai ulang.
///
/// Setiap fungsi mengembalikan pesan kesalahan jika input tidak valid, atau
/// `null` jika input valid, sesuai kontrak `FormFieldValidator` di Flutter.
/// Logika validasi dipisahkan dari widget agar mudah dibaca dan diuji.
library;

/// Batas panjang `CharField(max_length=255)` pada model Django.
const int maxTitleLength = 255;

/// Batas panjang bawaan `URLField` pada model Django.
const int maxUrlLength = 200;

/// Batas panjang `project_image_url` (`URLField(max_length=500)`) di Django.
const int maxImageUrlLength = 500;

/// Menolak input kosong atau yang hanya berisi spasi.
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName tidak boleh kosong!';
  }
  return null;
}

/// Menolak input kosong dan input yang melebihi [maxLength] karakter
/// setelah spasi di awal dan akhir dibuang.
String? validateRequiredWithMaxLength(
  String? value,
  String fieldName,
  int maxLength,
) {
  final requiredError = validateRequired(value, fieldName);
  if (requiredError != null) return requiredError;
  if (value!.trim().length > maxLength) {
    return '$fieldName maksimal $maxLength karakter!';
  }
  return null;
}

/// Memvalidasi URL opsional: boleh kosong, tetapi jika diisi harus berupa
/// URL `http` atau `https` yang lengkap dan tidak melebihi [maxLength].
String? validateOptionalUrl(String? value, {int maxLength = maxUrlLength}) {
  final url = value?.trim() ?? '';
  if (url.isEmpty) return null;
  if (url.length > maxLength) {
    return 'URL maksimal $maxLength karakter!';
  }
  final uri = Uri.tryParse(url);
  final hasValidScheme =
      uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  if (!hasValidScheme || uri.host.isEmpty || !uri.host.contains('.')) {
    return 'Masukkan URL valid yang diawali http:// atau https://';
  }
  return null;
}

/// Memvalidasi URL wajib: tidak boleh kosong dan harus berformat URL valid.
String? validateRequiredUrl(String? value, String fieldName) {
  final requiredError = validateRequired(value, fieldName);
  if (requiredError != null) return requiredError;
  return validateOptionalUrl(value);
}

/// Memastikan tanggal mulai sudah dipilih.
String? validateStartDate(DateTime? startedAt) {
  if (startedAt == null) {
    return 'Tanggal mulai wajib dipilih!';
  }
  return null;
}

/// Memvalidasi tanggal selesai.
///
/// Jika pendidikan masih berlangsung ([isOngoing]), tanggal selesai tidak
/// diperlukan. Jika tidak, tanggal selesai wajib diisi dan tidak boleh lebih
/// awal dari [startedAt].
String? validateEndDate(
  DateTime? endedAt, {
  required DateTime? startedAt,
  required bool isOngoing,
}) {
  if (isOngoing) return null;
  if (endedAt == null) {
    return 'Tanggal selesai wajib dipilih, atau aktifkan "Masih berlangsung"!';
  }
  if (startedAt != null && endedAt.isBefore(startedAt)) {
    return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
  }
  return null;
}

/// Mengubah tanggal menjadi format `dd/mm/yyyy` untuk ditampilkan.
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
