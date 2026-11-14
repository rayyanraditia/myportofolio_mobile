# MyPortfolio Mobile

Aplikasi mobile portofolio pribadi berbasis **Flutter**, bagian dari Proyek Individu mata kuliah Pemrograman Berbasis Platform (PBP) Fasilkom UI, Semester Gasal 2026/2027.

| | |
|---|---|
| **Nama** | Rayyan Raditia Pramana |
| **NPM** | 2506598955 |
| **Kelas** | PBP F |

## Fitur Saat Ini

- Tiga kartu informasi (`InfoCard`) berisi NPM, nama, dan kelas pemilik portofolio.
- Tiga tombol aksi (`ItemCard`) dengan warna latar berbeda:
  - **Lihat Proyek** (biru)
  - **Tambah Proyek** (hijau)
  - **Logout** (merah)
- Setiap tombol menampilkan `SnackBar` bertuliskan "Kamu telah menekan tombol [Nama Tombol]!".

## Struktur Proyek

```
lib/
├── main.dart   # Titik masuk aplikasi: MyApp dan MaterialApp beserta tema
└── menu.dart   # Halaman utama: MyHomePage, InfoCard, ItemHomepage, ItemCard
test/
└── widget_test.dart
```

## Cara Menjalankan

### Prasyarat
- Flutter SDK (dikembangkan dengan Flutter 3.47.9, Dart 3.13.7)
- Salah satu device: Chrome, emulator Android, simulator iOS, atau desktop

### Langkah
1. Clone repositori:
   ```bash
   git clone https://github.com/rayyanraditia/myportofolio_mobile.git
   cd myportofolio_mobile
   ```
2. Pasang dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:
   ```bash
   flutter run
   ```
4. Periksa kualitas kode dan jalankan test:
   ```bash
   flutter analyze
   flutter test
   ```

## Progres Mingguan

| Minggu | Tugas | Ringkasan |
|---|---|---|
| 8 | Tutorial 08 | Setup Flutter, memisahkan `menu.dart` dari `main.dart`, `MyHomePage` sebagai `StatelessWidget`, serta membuat `InfoCard` dan `ItemCard` |
| 8 | Tugas 7 | Data profil sendiri, warna latar unik per tombol melalui atribut `color` pada `ItemHomepage`, README, dan jawaban reflektif |

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child**

   Di Flutter, seluruh antarmuka tersusun dari widget yang saling bersarang membentuk struktur pohon (*widget tree*). Sebuah widget *parent* membungkus satu widget lewat properti `child` atau beberapa widget lewat properti `children`. Hubungan parent-child bekerja seperti ini:
   - **Konfigurasi mengalir ke bawah.** Parent mengirim data ke child melalui konstruktor. Contohnya, `MyHomePage` mengirim `title` dan `content` ke `InfoCard`.
   - **Layout:** *constraints go down, sizes go up, parent sets position*. Parent memberi batasan ukuran, child menentukan ukurannya di dalam batas itu, lalu parent mengatur posisi child.
   - **Child bisa mengakses data milik ancestor** lewat `BuildContext`, misalnya `Theme.of(context)`.

   Widget tree di aplikasi ini kira-kira seperti ini:
   ```
   MyApp
   └── MaterialApp
       └── MyHomePage
           └── Scaffold
               ├── AppBar → Text
               └── Padding → Column
                   ├── Row → InfoCard ×3 → Card → Container → Column → Text
                   ├── SizedBox
                   └── Center → Column
                       ├── Padding → Text
                       └── GridView → ItemCard ×3 → Material → InkWell → Container → Center → Column → Icon, Padding, Text
   ```

2. **Widget yang digunakan dan fungsinya**

   *Widget buatan sendiri:*
   - `MyApp` (StatelessWidget): root aplikasi yang membuat `MaterialApp` beserta temanya.
   - `MyHomePage` (StatelessWidget): halaman utama yang menyimpan data profil dan daftar tombol.
   - `InfoCard` (StatelessWidget): kartu berisi judul dan isi informasi profil (NPM, Name, Class).
   - `ItemCard` (StatelessWidget): tombol berbentuk kartu dengan ikon, teks, dan warna latar dari `ItemHomepage`.
   - `ItemHomepage` **bukan widget**, melainkan kelas model data (nama, ikon, warna) untuk setiap tombol.

   *Widget bawaan Flutter:*
   - `MaterialApp`: pembungkus aplikasi bergaya Material Design (tema, navigasi, judul).
   - `Scaffold`: kerangka halaman Material yang menyediakan slot `appBar` dan `body`.
   - `AppBar`: bilah judul di bagian atas halaman.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column` / `Row`: menyusun children secara vertikal atau horizontal.
   - `SizedBox`: memberi ruang kosong dengan ukuran tertentu.
   - `Center`: memposisikan child di tengah.
   - `GridView` (lewat `GridView.count`): menyusun `ItemCard` dalam grid tiga kolom.
   - `Card`: kontainer bergaya Material dengan sudut membulat dan bayangan (elevation), dipakai pada `InfoCard`.
   - `Container`: kotak serbaguna untuk mengatur ukuran (lebar) dan padding.
   - `Material`: memberi warna latar dan bentuk (border radius) pada `ItemCard`, sekaligus menjadi permukaan untuk efek *ripple*.
   - `InkWell`: membuat area dapat ditekan (`onTap`) dengan efek ripple.
   - `Icon`: menampilkan ikon Material.
   - `SnackBar`: pesan singkat di bagian bawah layar saat tombol ditekan.
   - `ScaffoldMessenger`: mengelola tampilan SnackBar. Diakses lewat `ScaffoldMessenger.of(context)` untuk menyembunyikan SnackBar lama dan menampilkan yang baru.
   - `MediaQuery`: menyediakan informasi layar. Diakses lewat `MediaQuery.of(context).size.width` untuk menghitung lebar `InfoCard`.
   - `Theme`: menyediakan tema. Diakses lewat `Theme.of(context).colorScheme.primary` untuk warna AppBar.

3. **Fungsi MaterialApp dan alasan dipakai sebagai root widget**

   `MaterialApp` adalah widget yang menyiapkan semua yang dibutuhkan aplikasi bergaya Material Design: tema global (`theme`/`ThemeData`), sistem navigasi (`Navigator` dan routes), judul aplikasi, lokalisasi, arah teks, `MediaQuery`, dan `ScaffoldMessenger` untuk SnackBar.

   Widget ini umumnya diletakkan sebagai root karena banyak widget Material bergantung pada ancestor yang disediakannya. `Scaffold`, `AppBar`, `SnackBar`, `Theme.of(context)`, dan `MediaQuery.of(context)` mencari data tersebut ke atas widget tree. Kalau `MaterialApp` tidak ada di root, widget-widget itu tidak menemukan ancestor-nya dan aplikasi akan error. Dengan menaruhnya di root, seluruh halaman di bawahnya otomatis mendapat tema dan layanan yang sama dan konsisten.

4. **StatelessWidget vs StatefulWidget**

   - `StatelessWidget` tidak punya *state* internal yang bisa berubah. Tampilannya sepenuhnya ditentukan oleh data yang diterima dari konstruktor, dan hanya dibangun ulang kalau parent-nya membangun ulang dengan data baru.
   - `StatefulWidget` dipasangkan dengan objek `State` yang menyimpan data yang dapat berubah selama widget hidup. Saat data berubah, `setState()` dipanggil sehingga Flutter menjalankan `build()` lagi dan memperbarui tampilan.

   **Kapan memilih yang mana:**
   - Pakai `StatelessWidget` kalau tampilan hanya bergantung pada input dan tidak berubah karena interaksi internal. Contohnya `InfoCard` dan `ItemCard` di proyek ini. Menampilkan SnackBar tidak memerlukan state karena SnackBar dikelola oleh `ScaffoldMessenger`.
   - Pakai `StatefulWidget` kalau widget harus mengingat dan memperbarui data sendiri. Contohnya counter, input form, checkbox, animasi, atau data yang dimuat dari internet.

5. **BuildContext dan penggunaannya di metode build**

   `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Setiap widget menerima `context` miliknya di metode `build(BuildContext context)`. Context ini penting karena menjadi cara widget berinteraksi dengan ancestor-nya: membaca tema, ukuran layar, atau mengakses layanan seperti `ScaffoldMessenger` dan `Navigator`.

   Penggunaannya di proyek ini:
   - `Theme.of(context).colorScheme.primary` untuk warna latar `AppBar` di `MyHomePage`.
   - `MediaQuery.of(context).size.width / 3.5` untuk lebar `InfoCard`.
   - `ScaffoldMessenger.of(context)` di `ItemCard` untuk menampilkan SnackBar.

   Karena pencarian dimulai dari posisi context ke atas, context yang dipakai harus berada **di bawah** widget yang dicari. Misalnya, `ScaffoldMessenger.of(context)` hanya berhasil kalau context berada di bawah `MaterialApp`.

6. **Hot reload vs hot restart**

   - **Hot reload** (tekan `r` saat `flutter run`) menyuntikkan kode Dart yang berubah ke aplikasi yang sedang berjalan, lalu membangun ulang widget tree **tanpa menghapus state**. Prosesnya sangat cepat (biasanya kurang dari 1 detik), cocok untuk mengubah UI seperti warna, teks, dan layout.
   - **Hot restart** (tekan `R`) mengompilasi ulang kode Dart dan memulai aplikasi dari awal (`main()` dijalankan lagi), sehingga **semua state di-reset**. Lebih lambat dari hot reload, tapi tetap lebih cepat dari menjalankan ulang aplikasi sepenuhnya.

   Hot reload tidak cukup, sehingga perlu hot restart, ketika ada perubahan pada:
   - Fungsi `main()` atau `initState()`, yang hanya dijalankan sekali di awal.
   - Variabel global dan field `static`, karena nilai awalnya tidak diinisialisasi ulang.
   - Struktur tipe, misalnya `enum` diubah menjadi `class` atau deklarasi tipe generik diubah.

   **Full restart** (hentikan aplikasi dengan `q`, lalu `flutter run` lagi) diperlukan ketika ada perubahan pada:
   - Kode native (Android/Kotlin, iOS/Swift) atau konfigurasi platform.
   - Dependensi di `pubspec.yaml` yang memiliki kode native (plugin), atau penambahan aset baru.
   