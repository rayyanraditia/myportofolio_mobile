import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';

import 'helpers/fake_backend.dart';

/// Tanggal pada bulan berjalan, sesuai bulan yang dibuka date picker.
String dayOfThisMonth(int day) {
  final now = DateTime.now();
  return formatDate(DateTime(now.year, now.month, day));
}

Future<void> pickDate(WidgetTester tester, String fieldLabel, int day) async {
  await tester.ensureVisible(find.widgetWithText(TextFormField, fieldLabel));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(TextFormField, fieldLabel));
  await tester.pumpAndSettle();
  await tester.tap(find.text('$day').last);
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester) async {
  // Tutup papan ketik terlebih dahulu (seperti menekan tombol Done), agar
  // field yang sedang fokus tidak menggulir layar kembali ke posisinya.
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Simpan'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

Future<void> fillValidForm(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Nama Institusi *'),
    'Universitas Indonesia',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Deskripsi Pendidikan *'),
    'S1 Ilmu Komputer',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'URL Logo Institusi (opsional)'),
    'https://ui.ac.id/logo.png',
  );
  await pickDate(tester, 'Tanggal Mulai *', 10);
  await pickDate(tester, 'Tanggal Selesai *', 20);
}

void main() {
  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
  }

  group('Akses formulir', () {
    testWidgets('Kartu Tambah Edukasi membuka form dan Back kembali', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(FakeBackend()));

      await tester.tap(find.text('Tambah Edukasi'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsOneWidget);

      // Simulasi tombol Back bawaan perangkat atau browser.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsNothing);
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('Drawer membuka form dan Home kembali ke halaman utama', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(FakeBackend()));

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Add Project'), findsOneWidget);
      expect(find.text('Add Education'), findsOneWidget);

      await tester.tap(find.text('Add Education'));
      await tester.pumpAndSettle();
      expect(find.byType(EducationFormPage), findsOneWidget);

      // Drawer yang sama tersedia di halaman formulir.
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(EducationFormPage), findsNothing);
    });
  });

  group('Validasi', () {
    testWidgets('Form kosong menampilkan error dan tidak membuka dialog', (
      tester,
    ) async {
      await openForm(tester);
      await tapSave(tester);

      expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
      expect(
        find.text('Deskripsi pendidikan tidak boleh kosong!'),
        findsOneWidget,
      );
      expect(find.text('Tanggal mulai wajib dipilih!'), findsOneWidget);
      expect(
        find.text(
          'Tanggal selesai wajib dipilih, atau aktifkan "Masih berlangsung"!',
        ),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Spasi saja dan URL tidak valid ditolak', (tester) async {
      await openForm(tester);
      await fillValidForm(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Institusi *'),
        '    ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'URL Logo Institusi (opsional)'),
        'ui.ac.id/logo.png',
      );
      await tapSave(tester);

      expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
      expect(
        find.text('Masukkan URL valid yang diawali http:// atau https://'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Tanggal selesai sebelum tanggal mulai ditolak', (
      tester,
    ) async {
      await openForm(tester);
      await fillValidForm(tester);
      // Tanggal mulai diubah menjadi setelah tanggal selesai (20).
      await pickDate(tester, 'Tanggal Mulai *', 25);
      await tapSave(tester);

      expect(
        find.text('Tanggal selesai tidak boleh sebelum tanggal mulai!'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('Dialog ringkasan', () {
    testWidgets('Input valid menampilkan semua isian lalu form direset', (
      tester,
    ) async {
      await openForm(tester);
      await fillValidForm(tester);
      await tester.tap(find.text('University'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Senior High School').last);
      await tester.pumpAndSettle();
      await tapSave(tester);

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Edukasi berhasil ditambahkan!'), findsOneWidget);
      for (final summary in [
        'Nama Institusi: Universitas Indonesia',
        'Deskripsi: S1 Ilmu Komputer',
        'Jenjang: Senior High School',
        'URL Logo: https://ui.ac.id/logo.png',
        'Tanggal Mulai: ${dayOfThisMonth(10)}',
        'Tanggal Selesai: ${dayOfThisMonth(20)}',
      ]) {
        expect(find.text(summary, findRichText: true), findsOneWidget);
      }

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(EducationFormPage), findsOneWidget);
      expect(find.text('Universitas Indonesia'), findsNothing);
      expect(find.text('University'), findsOneWidget);
    });

    testWidgets('Masih berlangsung tidak butuh tanggal selesai', (
      tester,
    ) async {
      await openForm(tester);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Institusi *'),
        'Universitas Indonesia',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Deskripsi Pendidikan *'),
        'S1 Ilmu Komputer',
      );
      await pickDate(tester, 'Tanggal Mulai *', 10);
      await tester.ensureVisible(find.text('Masih berlangsung'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Masih berlangsung'));
      await tester.pumpAndSettle();
      await tapSave(tester);

      expect(find.text('URL Logo: -', findRichText: true), findsOneWidget);
      expect(
        find.text('Tanggal Selesai: Masih berlangsung', findRichText: true),
        findsOneWidget,
      );
    });
  });

  testWidgets('Tombol Simpan terjangkau di layar ponsel saat keyboard tampil', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    // Simulasi papan ketik setinggi 300 px.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);

    await openForm(tester);
    expect(tester.takeException(), isNull);

    // Form dapat digulir sampai tombol Simpan terlihat di atas keyboard.
    await tester.scrollUntilVisible(
      find.text('Simpan'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
  });
}
