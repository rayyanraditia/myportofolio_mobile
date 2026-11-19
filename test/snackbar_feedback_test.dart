import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  const expectedButtons = <String, (IconData, Color)>{
    'Lihat Proyek': (Icons.folder, Colors.blue),
    'Tambah Proyek': (Icons.add_circle, Colors.green),
    'Tambah Edukasi': (Icons.school, Colors.purple),
    'Logout': (Icons.logout, Colors.red),
  };

  expectedButtons.forEach((name, expected) {
    final (icon, color) = expected;

    testWidgets('SnackBar tombol $name memakai ikon dan warna tombol', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      await tester.tap(find.text(name));
      await tester.pumpAndSettle();

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.behavior, SnackBarBehavior.floating);
      expect(snackBar.backgroundColor, color);
      expect(
        find.descendant(of: find.byType(SnackBar), matching: find.byIcon(icon)),
        findsOneWidget,
      );
      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  });
}
