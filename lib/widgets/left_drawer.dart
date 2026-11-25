import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Drawer navigasi yang muncul dari sisi kiri layar.
///
/// Berisi header aplikasi serta menu untuk berpindah ke halaman utama,
/// daftar proyek, form tambah proyek (dilindungi login), dan form tambah
/// edukasi, ditambah opsi Login atau Logout sesuai status sesi. Navigasi
/// halaman memakai [Navigator.pushReplacement] agar halaman lama diganti dan
/// tumpukan (stack) halaman tidak terus bertambah.
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  void _replaceWith(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Future<void> _login(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final loggedIn = await navigator.push<bool>(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    if (loggedIn ?? false) {
      navigator.pop(); // Tutup drawer.
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Login berhasil.')));
    }
  }

  Future<void> _logout(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await context.read<AuthState>().logout();
    navigator.pop(); // Tutup drawer.
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Berhasil logout.')));
  }

  @override
  Widget build(BuildContext context) {
    // watch: drawer dibangun ulang otomatis saat status login berubah.
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // maxLines + ellipsis menjaga header tetap muat walaupun
                // ukuran teks di perangkat diperbesar.
                Text(
                  'My Portfolio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Navigasi ke halaman utama portofolio
            onTap: () => _replaceWith(context, const MyHomePage()),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            // Navigasi ke daftar proyek dari API (publik)
            onTap: () => _replaceWith(context, const ProjectListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            // Form tambah proyek hanya bisa dibuka setelah login.
            onTap: () async {
              if (!await ensureLoggedIn(context)) return;
              if (!context.mounted) return;
              _replaceWith(context, const ProjectFormPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            // Navigasi ke halaman tambah edukasi
            onTap: () => _replaceWith(context, const EducationFormPage()),
          ),
          const Divider(),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => _login(context),
            ),
        ],
      ),
    );
  }
}
