import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'helpers/fake_backend.dart';

Future<void> fillField(WidgetTester tester, String label, String text) {
  return tester.enterText(find.widgetWithText(TextFormField, label), text);
}

Future<void> fillValidProject(WidgetTester tester) async {
  await fillField(tester, 'Title', 'MyPortfolio Mobile');
  await fillField(tester, 'Description', 'Aplikasi portofolio Flutter');
  await fillField(tester, 'Tech Stack', 'Flutter, Django');
  await fillField(tester, 'Project URL', 'https://github.com/example/mobile');
}

Future<void> tapSave(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Save'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Form menolak field wajib kosong tanpa memanggil API', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend, token: validToken),
    );

    await tapSave(tester);

    expect(find.text('Title tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Description tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tech stack tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Project URL tidak boleh kosong!'), findsOneWidget);
    expect(backend.requests, isEmpty);
  });

  testWidgets('Format URL yang salah ditolak', (tester) async {
    final backend = FakeBackend();
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend, token: validToken),
    );

    await fillValidProject(tester);
    await fillField(tester, 'Project URL', 'github.com/example');
    await fillField(tester, 'Project Image URL (Optional)', 'bukan-url');
    await tapSave(tester);

    expect(
      find.text('Masukkan URL valid yang diawali http:// atau https://'),
      findsNWidgets(2),
    );
    expect(backend.requests, isEmpty);
  });

  testWidgets('Sudah login: POST dengan token lalu dialog 201 tampil', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend, token: validToken),
    );

    await fillValidProject(tester);
    await tapSave(tester);

    final request = backend.requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/api/v1/projects/');
    expect(request.headers['Authorization'], 'Token $validToken');
    expect(jsonDecode(request.body), {
      'title': 'MyPortfolio Mobile',
      'description': 'Aplikasi portofolio Flutter',
      'tech_stack': 'Flutter, Django',
      'project_url': 'https://github.com/example/mobile',
      'project_image_url': '',
    });

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Title: MyPortfolio Mobile'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('MyPortfolio Mobile'), findsNothing);
  });

  testWidgets('Belum login: Save membuka login lalu melanjutkan POST', (
    tester,
  ) async {
    final backend = FakeBackend();
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend),
    );

    await fillValidProject(tester);
    await tapSave(tester);
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'owner',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(backend.requests.last.headers['Authorization'], 'Token $validToken');
  });

  testWidgets('401: logout lalu diminta login ulang', (tester) async {
    final backend = FakeBackend();
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend, token: 'expired'),
    );

    await fillValidProject(tester);
    await tapSave(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('403: tampilkan SnackBar tanpa dialog', (tester) async {
    final backend = FakeBackend(createStatus: 403);
    await tester.pumpWidget(
      wrapWithProviders(const ProjectFormPage(), backend, token: validToken),
    );

    await fillValidProject(tester);
    await tapSave(tester);

    expect(
      find.text(
        'Gagal menyimpan proyek: '
        'Akun ini tidak memiliki izin untuk aksi tersebut (403).',
      ),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Drawer: Add Project lalu Home kembali ke halaman utama', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestApp(FakeBackend(), token: validToken));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
  });
}
