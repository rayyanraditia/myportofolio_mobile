import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';

import 'helpers/fake_backend.dart';

void main() {
  const screenSizes = <String, Size>{
    'ponsel kecil': Size(320, 480),
    'ponsel standar': Size(360, 640),
    'ponsel landscape': Size(800, 360),
  };

  screenSizes.forEach((name, size) {
    testWidgets('Halaman utama tidak overflow pada $name', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(FakeBackend()));

      expect(tester.takeException(), isNull);
    });

    testWidgets('Form edukasi tidak overflow pada $name', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));

      expect(tester.takeException(), isNull);
    });
  });
}
