import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Tombol aksi berbentuk kartu berwarna yang dibangun dari [ItemHomepage].
///
/// Saat ditekan, kartu menampilkan [SnackBar] mengambang berisi ikon dan
/// nama tombol tersebut, dengan warna latar yang sama seperti tombolnya.
/// Jika [ItemHomepage.page] diisi, kartu juga membuka halaman tersebut
/// (setelah memastikan login jika [ItemHomepage.requiresLogin]). Kartu
/// dengan [ItemHomepage.isLogout] menjalankan logout.
class ItemCard extends StatelessWidget {
  /// Data tombol (nama, ikon, dan warna) yang ditampilkan kartu ini.
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  /// Menampilkan SnackBar mengambang dengan ikon dan warna tombol, sehingga
  /// pengguna langsung tahu tombol mana yang baru saja ditekan.
  void _showFeedback(ScaffoldMessengerState messenger, String message) {
    // SnackBar sebelumnya disembunyikan terlebih dahulu agar pesan yang
    // muncul selalu sesuai dengan tombol yang terakhir ditekan.
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: item.color,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(item.icon, color: Colors.white),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _onTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final pressed = "Kamu telah menekan tombol ${item.name}!";

    if (item.isLogout) {
      final auth = context.read<AuthState>();
      if (!auth.isLoggedIn) {
        _showFeedback(messenger, "$pressed Kamu belum login.");
        return;
      }
      await auth.logout();
      _showFeedback(messenger, "$pressed Berhasil logout.");
      return;
    }

    _showFeedback(messenger, pressed);

    final page = item.page;
    if (page == null) return;
    if (item.requiresLogin && !await ensureLoggedIn(context)) return;
    if (!context.mounted) return;

    // Navigator.push menumpuk halaman tujuan di atas halaman menu,
    // sehingga pengguna dapat kembali dengan tombol Back.
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          // LayoutBuilder memberi lebar kotak kepada konten agar teks tetap
          // dapat terbungkus (wrap). FittedBox dengan BoxFit.scaleDown hanya
          // mengecilkan konten jika tidak muat, sehingga tidak terjadi
          // overflow di layar kecil tanpa mengubah tampilan di layar besar.
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, color: Colors.white, size: 30.0),
                      const Padding(padding: EdgeInsets.all(3)),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
