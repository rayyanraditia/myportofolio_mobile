import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

/// Tombol aksi berbentuk kartu berwarna yang dibangun dari [ItemHomepage].
///
/// Saat ditekan, kartu menampilkan [SnackBar] mengambang berisi ikon dan
/// nama tombol tersebut, dengan warna latar yang sama seperti tombolnya.
/// Jika [ItemHomepage.page] diisi, kartu juga membuka halaman tersebut.
class ItemCard extends StatelessWidget {
  /// Data tombol (nama, ikon, dan warna) yang ditampilkan kartu ini.
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          // SnackBar sebelumnya disembunyikan terlebih dahulu agar pesan
          // yang muncul selalu sesuai dengan tombol yang terakhir ditekan.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              // SnackBar mengambang memakai ikon dan warna yang sama dengan
              // tombol, sehingga pengguna langsung tahu tombol mana yang
              // baru saja ditekan.
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
                        "Kamu telah menekan tombol ${item.name}!",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );

          // Navigator.push menumpuk halaman tujuan di atas halaman menu,
          // sehingga pengguna dapat kembali dengan tombol Back.
          final page = item.page;
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
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
