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

