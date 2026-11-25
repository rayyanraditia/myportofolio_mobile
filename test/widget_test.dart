import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

import 'helpers/fake_backend.dart';

void main() {
  testWidgets('Menampilkan profil dan SnackBar tombol', (tester) async {
    await tester.pumpWidget(buildTestApp(FakeBackend()));

    expect(find.text('2506598955'), findsOneWidget);
    expect(find.text('Rayyan Raditia Pramana'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(
      find.text('Kamu telah menekan tombol Logout! Kamu belum login.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Lihat Proyek membuka daftar proyek tanpa login', (tester) async {
    await tester.pumpWidget(buildTestApp(FakeBackend()));

    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('Tambah Proyek meminta login jika belum login', (tester) async {
    await tester.pumpWidget(buildTestApp(FakeBackend()));

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
  });

  testWidgets('Tambah Proyek langsung membuka form jika sudah login', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(FakeBackend(), token: validToken));

    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    // Simulasi tombol Back sistem (Android/browser).
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsNothing);
  });

  testWidgets('Tambah Edukasi tetap bisa dibuka tanpa login', (tester) async {
    await tester.pumpWidget(buildTestApp(FakeBackend()));

    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();

    expect(find.byType(EducationFormPage), findsOneWidget);
  });
}
