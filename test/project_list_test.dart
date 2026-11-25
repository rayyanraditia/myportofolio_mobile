import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

import 'helpers/fake_backend.dart';

void main() {
  testWidgets('Menampilkan proyek dari API dan membuka detail', (tester) async {
    final backend = FakeBackend(projects: [sampleProject()]);
    await tester.pumpWidget(
      wrapWithProviders(const ProjectListScreen(), backend),
    );

    // Indikator loading tampil sebelum response diterima.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.text('Portfolio Website'), findsOneWidget);
    expect(find.textContaining('Django, Tailwind'), findsOneWidget);
    expect(backend.requests.single.headers['Authorization'], isNull);

    await tester.tap(find.text('Portfolio Website'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('Website portofolio pribadi'), findsOneWidget);
    expect(find.text('https://github.com/example/portfolio'), findsOneWidget);
    // URL gambar kosong, jadi widget gambar tidak ditampilkan.
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Detail menampilkan gambar jika URL gambar tersedia', (
    tester,
  ) async {
    final backend = FakeBackend(
      projects: [sampleProject(imageUrl: 'https://example.com/image.png')],
    );
    await tester.pumpWidget(
      wrapWithProviders(const ProjectListScreen(), backend),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Portfolio Website'));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Daftar kosong menampilkan pesan', (tester) async {
    await tester.pumpWidget(
      wrapWithProviders(const ProjectListScreen(), FakeBackend()),
    );
    await tester.pumpAndSettle();

    expect(find.text('No projects found.'), findsOneWidget);
  });

  testWidgets('Error menampilkan pesan dan Retry memuat ulang', (tester) async {
    final backend = FakeBackend(projects: [sampleProject()], listStatus: 500);
    await tester.pumpWidget(
      wrapWithProviders(const ProjectListScreen(), backend),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load projects'), findsOneWidget);
    expect(find.textContaining('(500)'), findsOneWidget);

    backend.listStatus = 200;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Portfolio Website'), findsOneWidget);
    expect(backend.requests, hasLength(2));
  });
}
