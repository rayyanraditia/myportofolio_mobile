import 'package:flutter/material.dart';

/// Halaman utama aplikasi MyPortfolio Mobile.
///
/// Menampilkan identitas pemilik portofolio dalam tiga [InfoCard] dan
/// tombol-tombol aksi dalam bentuk [ItemCard]. Widget ini bersifat
/// [StatelessWidget] karena seluruh datanya tetap (konstan) dan tidak
/// berubah selama aplikasi berjalan.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  /// Nomor Pokok Mahasiswa pemilik portofolio.
  final String npm = "2506598955";

  /// Nama lengkap pemilik portofolio.
  final String nama = "Rayyan Raditia Pramana";

  /// Kelas mata kuliah PBP pemilik portofolio.
  final String kelas = "PBP F";

  /// Daftar tombol aksi yang ditampilkan di halaman utama.
  ///
  /// Setiap tombol membawa warnanya sendiri melalui [ItemHomepage.color],
  /// sehingga [ItemCard] tidak memerlukan percabangan untuk menentukan warna.
  /// Daftar dibuat `const` agar hanya dialokasikan sekali saat kompilasi.
  final List<ItemHomepage> items = const [
    ItemHomepage("Lihat Proyek", Icons.folder, Colors.blue),
    ItemHomepage("Tambah Proyek", Icons.add_circle, Colors.green),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // SingleChildScrollView mencegah overflow ketika tinggi layar tidak
      // cukup, misalnya saat ponsel dalam mode landscape.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IntrinsicHeight + stretch menyamakan tinggi ketiga kartu,
            // sedangkan Expanded membagi lebar Row secara rata sehingga
            // kartu selalu muat di layar sempit.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: npm),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Name', content: nama),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Class', content: kelas),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Selamat datang di MyPortfolio Mobile!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GridView.count(
                    // Scroll ditangani oleh SingleChildScrollView di atas.
                    // GridView tidak boleh memakai PrimaryScrollController
                    // yang sama dan tidak perlu scroll sendiri.
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu informasi yang menampilkan satu pasang judul dan isi,
/// misalnya `NPM` dan nomor NPM pemilik portofolio.
class InfoCard extends StatelessWidget {
  /// Label informasi yang ditampilkan dengan huruf tebal, misalnya `Name`.
  final String title;

  /// Nilai informasi yang ditampilkan di bawah [title].
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        // Padding horizontal dibuat lebih kecil agar teks panjang seperti
        // NPM tetap muat dalam satu baris di layar ponsel.
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Model data untuk satu tombol aksi di halaman utama.
///
/// Kelas ini bukan widget; datanya digunakan oleh [ItemCard] untuk
/// menampilkan nama, ikon, dan warna latar tombol.
class ItemHomepage {
  /// Teks yang ditampilkan pada tombol dan pada pesan SnackBar.
  final String name;

  /// Ikon Material yang ditampilkan di atas [name].
  final IconData icon;

  /// Warna latar tombol; setiap tombol memiliki warna yang berbeda.
  final Color color;

  const ItemHomepage(this.name, this.icon, this.color);
}

/// Tombol aksi berbentuk kartu berwarna yang dibangun dari [ItemHomepage].
///
/// Saat ditekan, kartu menampilkan [SnackBar] berisi nama tombol tersebut.
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
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );
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
