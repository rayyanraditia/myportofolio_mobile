import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
  }

  testWidgets('Form menolak nama dan deskripsi kosong', (tester) async {
    await openForm(tester);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Form valid menampilkan isian di pop-up lalu direset', (
    tester,
  ) async {
    await openForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama Proyek'),
      'MyPortfolio Mobile',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Deskripsi Proyek'),
      'Aplikasi portofolio Flutter',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Teknologi yang Digunakan'),
      'Flutter, Dart',
    );
    await tester.tap(find.text('Web Development'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Nama Proyek: MyPortfolio Mobile'), findsOneWidget);
    expect(find.text('Deskripsi: Aplikasi portofolio Flutter'), findsOneWidget);
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Dart'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('MyPortfolio Mobile'), findsNothing);
    expect(find.text('Web Development'), findsOneWidget);
  });

  testWidgets('Drawer berpindah antara Home dan Add Project', (tester) async {
    await tester.pumpWidget(const MyApp());

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
