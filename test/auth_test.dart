import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'helpers/fake_backend.dart';

Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
}

Future<void> fillLogin(WidgetTester tester, String password) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Username'),
    'owner',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    password,
  );
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
}

void main() {
  group('LoginScreen', () {
    testWidgets('Username dan password wajib diisi', (tester) async {
      final backend = FakeBackend();
      await tester.pumpWidget(wrapWithProviders(const LoginScreen(), backend));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.text('Username cannot be empty!'), findsOneWidget);
      expect(find.text('Password cannot be empty!'), findsOneWidget);
      expect(backend.requests, isEmpty);
    });

    testWidgets('Password salah menampilkan SnackBar', (tester) async {
      final backend = FakeBackend();
      await tester.pumpWidget(wrapWithProviders(const LoginScreen(), backend));

      await fillLogin(tester, 'wrong');

      expect(find.text('Username atau password salah (400).'), findsOneWidget);
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  group('Drawer', () {
    testWidgets('Login lalu Logout mengubah opsi di drawer', (tester) async {
      final backend = FakeBackend();
      await tester.pumpWidget(buildTestApp(backend));

      await openDrawer(tester);
      expect(find.text('Login'), findsOneWidget);
      // Kartu "Logout" di halaman utama selalu ada; yang dicek di drawer.
      expect(
        find.descendant(of: find.byType(Drawer), matching: find.text('Logout')),
        findsNothing,
      );

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await fillLogin(tester, 'secret');
      expect(find.text('Login berhasil.'), findsOneWidget);

      await openDrawer(tester);
      // Kartu Logout di halaman utama juga bertuliskan "Logout",
      // jadi cari ListTile di dalam drawer.
      final drawerLogout = find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Logout'),
      );
      expect(drawerLogout, findsOneWidget);

      await tester.tap(drawerLogout);
      await tester.pumpAndSettle();
      expect(find.text('Berhasil logout.'), findsOneWidget);
      expect(backend.requests.last.url.path, '/api/v1/auth/logout/');

      await openDrawer(tester);
      expect(
        find.descendant(of: find.byType(Drawer), matching: find.text('Login')),
        findsOneWidget,
      );
    });

    testWidgets('Add Project di drawer meminta login terlebih dahulu', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(FakeBackend()));

      await openDrawer(tester);
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });

  testWidgets('Kartu Logout mencabut token saat sudah login', (tester) async {
    final backend = FakeBackend();
    await tester.pumpWidget(buildTestApp(backend, token: validToken));

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(
      find.text('Kamu telah menekan tombol Logout! Berhasil logout.'),
      findsOneWidget,
    );
    expect(
      backend.requests.single.headers['Authorization'],
      'Token $validToken',
    );
  });

  test('AuthState.logout tetap menghapus token walau server menolak', () async {
    final backend = FakeBackend();
    final auth = AuthState(backend.apiClient, initialToken: 'expired-token');

    await auth.logout();

    expect(auth.isLoggedIn, isFalse);
    expect(auth.token, isNull);
  });
}
