import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';

void main() {
  group('validateRequired', () {
    test('menolak null, string kosong, dan string berisi spasi saja', () {
      expect(validateRequired(null, 'Nama'), 'Nama tidak boleh kosong!');
      expect(validateRequired('', 'Nama'), 'Nama tidak boleh kosong!');
      expect(validateRequired('   ', 'Nama'), 'Nama tidak boleh kosong!');
    });

    test('menerima teks yang berisi karakter selain spasi', () {
      expect(validateRequired(' UI ', 'Nama'), isNull);
    });
  });

  group('validateRequiredWithMaxLength', () {
    test('menolak teks yang melebihi batas panjang', () {
      expect(
        validateRequiredWithMaxLength('a' * 256, 'Nama', 255),
        'Nama maksimal 255 karakter!',
      );
    });

    test('menerima teks tepat di batas panjang setelah di-trim', () {
      expect(
        validateRequiredWithMaxLength('  ${'a' * 255}  ', 'Nama', 255),
        isNull,
      );
    });
  });

  group('validateOptionalUrl', () {
    test('menerima input kosong karena URL bersifat opsional', () {
      expect(validateOptionalUrl(null), isNull);
      expect(validateOptionalUrl('   '), isNull);
    });

    test('menerima URL http dan https yang lengkap', () {
      expect(validateOptionalUrl('https://ui.ac.id/logo.png'), isNull);
      expect(validateOptionalUrl('http://example.com'), isNull);
    });

    test('menolak URL tanpa skema, skema lain, atau domain tidak lengkap', () {
      const message = 'Masukkan URL valid yang diawali http:// atau https://';
      expect(validateOptionalUrl('ui.ac.id'), message);
      expect(validateOptionalUrl('ftp://ui.ac.id'), message);
      expect(validateOptionalUrl('https://localhost'), message);
      expect(validateOptionalUrl('bukan url'), message);
    });

    test('menolak URL yang lebih dari 200 karakter', () {
      final longUrl = 'https://example.com/${'a' * 200}';
      expect(validateOptionalUrl(longUrl), 'URL maksimal 200 karakter!');
    });
  });

  group('validasi tanggal', () {
    final start = DateTime(2025, 8, 1);

    test('tanggal mulai wajib dipilih', () {
      expect(validateStartDate(null), 'Tanggal mulai wajib dipilih!');
      expect(validateStartDate(start), isNull);
    });

    test('tanggal selesai tidak diperlukan jika masih berlangsung', () {
      expect(validateEndDate(null, startedAt: start, isOngoing: true), isNull);
    });

    test('tanggal selesai wajib jika tidak sedang berlangsung', () {
      expect(
        validateEndDate(null, startedAt: start, isOngoing: false),
        'Tanggal selesai wajib dipilih, atau aktifkan "Masih berlangsung"!',
      );
    });

    test('tanggal selesai tidak boleh sebelum tanggal mulai', () {
      expect(
        validateEndDate(
          DateTime(2025, 7, 31),
          startedAt: start,
          isOngoing: false,
        ),
        'Tanggal selesai tidak boleh sebelum tanggal mulai!',
      );
      expect(
        validateEndDate(start, startedAt: start, isOngoing: false),
        isNull,
      );
    });
  });

  test('formatDate menghasilkan format dd/mm/yyyy', () {
    expect(formatDate(DateTime(2026, 3, 5)), '05/03/2026');
  });
}