import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Shows owner information and menu feedback', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506598955'), findsOneWidget);
    expect(find.text('Rayyan Raditia Pramana'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);

    for (final label in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $label!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
}
