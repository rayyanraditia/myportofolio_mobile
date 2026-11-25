import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Memastikan pengguna sudah login sebelum membuka layar yang dilindungi.
///
/// Jika belum login, [LoginScreen] dibuka dan fungsi menunggu hasilnya.
/// Mengembalikan `true` hanya jika pengguna sudah atau berhasil login.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;

  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
  return loggedIn ?? false;
}
