# MyPortfolio Mobile

Aplikasi mobile portofolio pribadi berbasis **Flutter**, bagian dari Proyek Individu mata kuliah Pemrograman Berbasis Platform (PBP) Fasilkom UI, Semester Gasal 2026/2027.

| | |
|---|---|
| **Nama** | Rayyan Raditia Pramana |
| **NPM** | 2506598955 |
| **Kelas** | PBP F |

## Fitur Saat Ini

- Tiga kartu informasi (`InfoCard`) berisi NPM, nama, dan kelas pemilik portofolio.
- Empat tombol aksi (`ItemCard`) dengan warna latar berbeda. Jumlah kolomnya menyesuaikan lebar layar (2 kolom di ponsel, 4 kolom di layar lebar):
  - **Lihat Proyek** (biru)
  - **Tambah Proyek** (hijau), membuka form tambah proyek
  - **Tambah Edukasi** (ungu), membuka form tambah edukasi
  - **Logout** (merah)
- Setiap tombol menampilkan `SnackBar` mengambang bertuliskan "Kamu telah menekan tombol [Nama Tombol]!", lengkap dengan ikon dan warna latar yang sama seperti tombol yang ditekan.
- Tata letak responsif: kartu informasi dan tombol menyesuaikan lebar layar tanpa *overflow*, dan halaman dapat di-scroll pada mode landscape.
- Drawer navigasi (`LeftDrawer`) dengan opsi **Home**, **Add Project**, dan **Add Education**. Drawer yang sama dipakai di halaman utama dan kedua halaman form.
- Halaman form tambah proyek (`ProjectFormPage`) dengan validasi, dropdown kategori, dan pop-up yang menampilkan isian form.
- Halaman form tambah edukasi (`EducationFormPage`) yang field-nya mengikuti model `Education` di proyek Django:

  | Field di form | Field di Django | Input | Aturan validasi |
  |---|---|---|---|
  | Nama Institusi | `title` | `TextFormField` dengan penghitung karakter | Wajib, tidak boleh hanya spasi, maksimal 255 karakter |
  | Deskripsi Pendidikan | `description` | `TextFormField` multi-baris | Wajib, tidak boleh hanya spasi |
  | Jenjang Pendidikan | `category` | `DropdownButtonFormField` | Pilihan Junior High School, Senior High School, atau University (default University) |
  | URL Logo Institusi | `thumbnail` | `TextFormField` dengan keyboard URL | Opsional; jika diisi harus URL `http`/`https` dengan domain lengkap, maksimal 200 karakter |
  | Tanggal Mulai | `started_at` | `showDatePicker()` | Wajib dipilih |
  | Masih berlangsung | `ended_at = null` (`is_ongoing`) | `SwitchListTile` | Jika aktif, tanggal selesai dikosongkan dan tidak wajib |
  | Tanggal Selesai | `ended_at` | `showDatePicker()` | Wajib jika tidak sedang berlangsung, dan tidak boleh sebelum tanggal mulai |

  Setelah semua input valid, tombol **Simpan** menampilkan seluruh isian dalam `AlertDialog`. Tombol **OK** menutup dialog dan mengosongkan form.

  Catatan: di Django, `started_at` diisi otomatis (`auto_now_add`). Di aplikasi mobile, tanggal mulai dibuat sebagai input agar pengguna dapat mencatat kapan pendidikan dimulai, sesuai instruksi tugas tentang `showDatePicker()` dan urutan tanggal. Nilai jenjang disimpan sama persis dengan pilihan Django (termasuk ejaan `juniour high school`) agar nantinya kompatibel dengan REST API.

## Struktur Proyek

```
lib/
├── main.dart                  # Titik masuk aplikasi: MyApp dan MaterialApp beserta tema
├── models/
│   └── education.dart         # Model data Education dan enum EducationLevel
├── screens/
│   ├── menu.dart              # Halaman utama: MyHomePage, InfoCard, ItemHomepage
│   ├── project_form.dart      # Halaman form tambah proyek: ProjectFormPage
│   └── education_form.dart    # Halaman form tambah edukasi: EducationFormPage
├── utils/
│   └── form_validators.dart   # Fungsi validasi form yang dapat dipakai ulang
└── widgets/
    ├── left_drawer.dart       # Drawer navigasi: LeftDrawer
    └── project_card.dart      # Tombol aksi berbentuk kartu: ItemCard
test/
├── widget_test.dart             # Test data profil, SnackBar, dan navigasi tombol
├── responsive_layout_test.dart  # Test regresi overflow halaman utama dan form edukasi
├── snackbar_feedback_test.dart  # Test ikon, warna, dan gaya SnackBar per tombol
├── project_form_test.dart       # Test validasi form proyek, pop-up, dan navigasi drawer
├── education_form_test.dart     # Test akses form edukasi, validasi, dialog, dan layar ponsel
└── form_validators_test.dart    # Unit test setiap fungsi validasi
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
   Untuk menjalankan di Chrome (dipakai untuk menguji opsi **Home** di drawer):
   ```bash
   flutter run -d chrome
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
| 8 | Tugas 7 (perbaikan) | Memperbaiki *overflow* layout di layar ponsel (`Expanded`, `FittedBox`, `SingleChildScrollView`) dan menambahkan test regresi layout |
| 8 | Tugas 7 (kualitas kode) | Konstruktor `const` pada `MyHomePage` dan `ItemHomepage`, docstring pada seluruh class dan field, serta komentar yang menjelaskan keputusan layout |
| 8 | Tugas 7 (fitur tambahan) | `SnackBar` mengambang dengan ikon dan warna latar sesuai tombol yang ditekan, beserta test-nya |
| 9 | Tutorial 09 | Migrasi ke paket `material_ui`, drawer navigasi, halaman form tambah proyek dengan validasi dan pop-up, navigasi dari tombol **Tambah Proyek**, serta pemisahan berkas ke `screens/` dan `widgets/` |
| 9 | Tugas 8 | Form tambah edukasi sesuai model `Education` (date picker, switch "Masih berlangsung", validasi panjang, URL, dan urutan tanggal), kartu **Tambah Edukasi** dengan `Navigator.push()`, opsi **Add Education** di drawer, grid tombol yang responsif, validator terpisah di `utils/`, serta 25 test baru |

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
               └── SingleChildScrollView → Column
                   ├── IntrinsicHeight → Row → Expanded ×3 → InfoCard → Card → Padding → Column → Text
                   ├── SizedBox
                   └── Center → Column
                       ├── Padding → Text
                       └── GridView → ItemCard ×3 → Material → InkWell → Container → LayoutBuilder → FittedBox → SizedBox → Column → Icon, Padding, Text
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
   - `GridView`: menyusun `ItemCard` dalam bentuk grid. Pada Tugas 7 memakai `GridView.count` dengan tiga kolom; sejak Tugas 8 memakai `GridView.extent` agar jumlah kolom menyesuaikan lebar layar.
   - `Card`: kontainer bergaya Material dengan sudut membulat dan bayangan (elevation), dipakai pada `InfoCard`.
   - `Container`: kotak serbaguna, dipakai untuk memberi padding di dalam `ItemCard`.
   - `SingleChildScrollView`: membuat isi halaman dapat di-scroll agar tidak *overflow* pada layar pendek (misalnya mode landscape).
   - `IntrinsicHeight`: menyamakan tinggi ketiga `InfoCard` mengikuti kartu yang paling tinggi.
   - `Expanded`: membagi ruang di dalam `Row`. Dipakai untuk membagi lebar secara rata ke ketiga `InfoCard`, dan untuk memberi sisa lebar SnackBar kepada teks pesan agar dapat terbungkus.
   - `LayoutBuilder`: memberikan ukuran (*constraints*) dari parent kepada `ItemCard` untuk menentukan lebar konten.
   - `FittedBox`: mengecilkan isi `ItemCard` secara proporsional hanya jika tidak muat di dalam kotaknya.
   - `Material`: memberi warna latar dan bentuk (border radius) pada `ItemCard`, sekaligus menjadi permukaan untuk efek *ripple*.
   - `InkWell`: membuat area dapat ditekan (`onTap`) dengan efek ripple.
   - `Icon`: menampilkan ikon Material.
   - `SnackBar`: pesan singkat di bagian bawah layar saat tombol ditekan. Dibuat mengambang (`SnackBarBehavior.floating`) dengan ikon dan warna latar yang sama seperti tombolnya.
   - `ScaffoldMessenger`: mengelola tampilan SnackBar. Diakses lewat `ScaffoldMessenger.of(context)` untuk menyembunyikan SnackBar lama dan menampilkan yang baru.
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
   - `LayoutBuilder` di `ItemCard` memanggil `builder(context, constraints)` sehingga konten bisa menyesuaikan ukuran kotak yang diberikan parent.
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

### Tugas 8

1. **Perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`**

   `Navigator` menyimpan halaman (route) dalam bentuk tumpukan (*stack*).
   - `push()` menaruh route baru **di atas** route yang sedang tampil. Route lama tetap ada di bawahnya, sehingga pengguna bisa kembali.
   - `pushReplacement()` **mengganti** route paling atas dengan route baru. Route lama dibuang dari stack, jadi tombol Back tidak akan kembali ke sana.
   - `pop()` **membuang** route paling atas sehingga route di bawahnya tampil kembali. Method ini juga dipakai untuk menutup dialog.

   Formulir edukasi dibuka dari kartu **Tambah Edukasi** dengan `Navigator.push()`. Stack menjadi `[MyHomePage, EducationFormPage]`, sehingga tombol Back bawaan perangkat atau browser memanggil `pop()` dan membawa pengguna kembali ke halaman utama.

   Opsi **Home** di drawer memakai `Navigator.pushReplacement()` dengan `MaterialPageRoute(builder: (context) => const MyHomePage())`. Route formulir yang sedang tampil (beserta drawer-nya) diganti dengan halaman utama yang baru, sehingga stack tidak terus bertambah setiap kali pengguna berpindah lewat drawer.

2. **Konsistensi struktur dengan `Scaffold`, `AppBar`, dan `Drawer`**

   Setiap halaman dibangun dengan kerangka yang sama: `Scaffold` menyediakan slot `appBar`, `drawer`, dan `body`. Akibatnya posisi judul di atas, tombol menu ☰ di kiri atas, dan konten di tengah selalu sama di halaman utama, form proyek, dan form edukasi. Drawer dibuat satu kali sebagai widget `LeftDrawer` di `lib/widgets/left_drawer.dart`, lalu dipasang dengan `drawer: const LeftDrawer()` di ketiga halaman. Menambah menu baru cukup dilakukan di satu tempat dan langsung muncul di semua halaman.

   Contoh warna tema yang dipakai di lebih dari satu halaman: `main.dart` membuat tema dari `ColorScheme.fromSeed(seedColor: Colors.indigo)`. Warna `Theme.of(context).colorScheme.primary` dari tema itu dipakai sebagai warna `AppBar` halaman utama, warna `AppBar` form edukasi, dan warna tombol **Simpan** di form edukasi. Header drawer juga memakai warna indigo yang sama keluarganya.

3. **Alasan tata letak formulir**

   Formulir disusun sebagai satu kolom (`Column` dengan `CrossAxisAlignment.stretch`), satu field per baris dengan lebar penuh. Susunan ini paling mudah dibaca dari atas ke bawah di layar ponsel yang sempit, dan setiap field punya label, ikon, serta ruang pesan error sendiri. Urutannya mengikuti alur berpikir pengguna: identitas institusi, jenjang, logo, lalu periode waktu, dan tombol **Simpan** berada di paling bawah dengan lebar penuh agar mudah ditekan.

   - **Widget pengatur jarak:** `SingleChildScrollView` memberi `padding` 16 px di sekeliling form, dan `SizedBox(height: 8/16/24)` memberi jarak antar-field. Jarak ini memisahkan field secara visual dan menyediakan ruang agar pesan error di bawah field tidak menempel ke field berikutnya.
   - **Widget penggulir:** saat papan ketik muncul, `Scaffold` memperkecil area `body`. Tanpa penggulir, `Column` akan *overflow*. `SingleChildScrollView` membuat seluruh field dan tombol **Simpan** tetap bisa dijangkau dengan menggulir, dan `keyboardDismissBehavior: onDrag` menutup papan ketik saat pengguna menggulir. Dropdown jenjang memakai `isExpanded: true` agar teks pilihannya tidak melebar keluar layar sempit. Perilaku ini diuji di `test/education_form_test.dart` (layar 360×640 dengan papan ketik setinggi 300 px) dan `test/responsive_layout_test.dart`.

4. **Peran `GlobalKey<FormState>`, `validator`, dan `validate()`**

   - `GlobalKey<FormState>` (`_formKey`) dipasang di widget `Form` dan menjadi "pegangan" untuk mengakses state form dari luar widget field, misalnya dari fungsi `_submit()` milik tombol **Simpan**.
   - `validator` adalah fungsi di setiap field yang mengembalikan pesan error (`String`) jika isian tidak valid, atau `null` jika valid. Di proyek ini, logikanya dipisahkan ke `lib/utils/form_validators.dart`.
   - Saat **Simpan** ditekan, `_formKey.currentState!.validate()` menjalankan **semua** validator sekaligus, menampilkan pesan error di bawah field yang salah, lalu mengembalikan `true` hanya jika semuanya valid. Dialog ringkasan hanya dibuka ketika hasilnya `true`.

   Contoh nilai yang ditolak: URL logo `ui.ac.id/logo.png`. Field ini memakai `keyboardType: TextInputType.url`, tetapi jenis keyboard hanya mengubah tata letak tombol di papan ketik ponsel, bukan membatasi isi yang boleh dimasukkan. Pengguna tetap bisa mengetik teks tanpa `https://`, menempelkan teks apa pun, atau memakai keyboard fisik di Chrome. Hal yang sama berlaku untuk nama institusi berisi spasi saja (`"    "`) yang lolos dari keyboard mana pun, dan untuk tanggal: date picker selesai memang membatasi tanggal paling awal sesuai tanggal mulai, tetapi pengguna masih bisa mengubah tanggal mulai setelahnya. Karena itu aturan model tetap harus diperiksa oleh `validator`.

## AI Disclosure

### Tugas 7

**Tools yang digunakan**
- **Claude Code** (model Claude Opus 5.5) di aplikasi desktop Claude.

**Strategi prompting**
- **AI sebagai pemandu, bukan pengeksekusi.** Saya meminta AI tidak mengubah file apa pun kecuali diminta secara eksplisit. AI hanya menjelaskan perubahan dan langkah-langkahnya di chat, lalu saya sendiri yang mengetik kode, menjalankan perintah, membuat commit, dan membuat Pull Request.
- **Berbasis rubrik.** Di awal, AI diminta membaca halaman soal dan rubrik penilaian serta memeriksa isi proyek, lalu memetakan checklist mana yang sudah dan belum terpenuhi.
- **Bertahap.** Pekerjaan dipecah per langkah: (1) warna tombol, (2) README dan jawaban reflektif, (3) AI disclosure. Saya baru lanjut ke langkah berikutnya setelah langkah sebelumnya diverifikasi.
- **Meminta verifikasi, bukan sekadar jawaban.** Setelah setiap langkah, saya meminta AI memeriksa hasil kerja saya: status git, isi commit, `flutter analyze`, `flutter test`, status Pull Request di GitHub, dan tampilan aplikasi yang dijalankan versi web-nya.

**Bagian yang dibantu AI**
- Menganalisis checklist dan rubrik Tugas 7 terhadap kondisi proyek.
- Instruksi perubahan kode untuk warna latar per tombol: atribut `color` pada `ItemHomepage` dan `item.color` pada `ItemCard`. Kodenya saya ketik sendiri.
- Alur Git: branch per fitur, pesan *conventional commits*, serta Pull Request dengan *merge commit*.
- Draf README: deskripsi, cara menjalankan, progres mingguan, dan draf jawaban pertanyaan reflektif yang kemudian saya baca dan pahami.
- Verifikasi hasil: pengecekan git, analisis statis, test, dan tangkapan layar aplikasi.

**Log interaksi AI**

Setiap tahap mengikuti pola yang sama. Saya menetapkan tujuan dan batasan, AI memberi analisis atau instruksi, saya mengimplementasikan sendiri, lalu hasilnya divalidasi sebelum lanjut ke tahap berikutnya.

| Tahap | Tujuan | Batasan / instruksi yang saya tetapkan | Keputusan dan tindakan saya | Validasi |
|---|---|---|---|---|
| 1. Analisis kebutuhan | Memetakan checklist dan rubrik Tugas 7 terhadap kondisi repositori | AI hanya boleh membaca (*read-only*) halaman soal dan isi proyek, tanpa mengubah file | Menetapkan urutan pengerjaan berdasarkan bagian yang belum terpenuhi: warna tombol, README, AI disclosure, riwayat commit | Tabel status checklist dan hasil `flutter analyze` awal (*No issues found*) |
| 2. Penetapan alur kerja | Menjaga agar implementasi tetap dikerjakan sendiri | AI berperan sebagai *reviewer* dan pemandu: perubahan dijelaskan per langkah di chat, tidak ditulis langsung ke file | Semua kode, commit, dan Pull Request saya kerjakan sendiri | — |
| 3. Review terhadap rubrik | Memastikan rencana Git memenuhi kriteria nilai tertinggi | Meminta AI meninjau ulang rubrik Git & Disiplin | Menemukan bahwa rencana awal (commit langsung ke `main`) belum memenuhi syarat *branching* per fitur, lalu meminta rencana disusun ulang dari awal | Rencana baru memakai branch fitur, *conventional commits*, dan Pull Request dengan *merge commit* |
| 4. Implementasi warna tombol | Warna latar unik per `ItemCard` tanpa logika pewarnaan berulang | Setiap langkah wajib memiliki hasil yang diharapkan yang bisa diperiksa | Mengimplementasikan atribut `color` pada `ItemHomepage` dalam 2 commit bertahap di branch `feat/item-card-colors` | `flutter analyze`, `flutter test`, dan pengecekan visual aplikasi (biru, hijau, merah, serta SnackBar) |
| 5. Integrasi ke `main` | Menggabungkan fitur melalui Pull Request | Status di GitHub diverifikasi langsung, bukan diasumsikan | Membuat dan me-merge PR #1 setelah pengecekan menunjukkan PR belum terbentuk | Grafik `git log --graph` menunjukkan merge commit, dan PR #1 berstatus *Merged* |
| 6. Dokumentasi | README, jawaban reflektif, dan AI disclosure | Draf jawaban harus merujuk ke kode proyek ini, bukan penjelasan generik | Meninjau dan menyesuaikan draf, membagi perubahan ke beberapa commit di branch `docs/readme-tugas-7`, serta merapikan *trailing whitespace* | Preview Markdown dan `git diff --check` |
| 7. Pengujian responsif | Memastikan aplikasi tidak rusak di layar ponsel sungguhan | Aplikasi diuji pada beberapa ukuran layar, bukan hanya di jendela desktop | Mengimplementasikan perbaikan *overflow* di branch `fix/responsive-layout` dan menambahkan test regresi | `flutter test` pada ukuran 320×480, 360×640, dan 800×360, serta pengecekan visual |
| 8. Kualitas kode | Kode mudah dipahami dan efisien | Perubahan kualitas kode tidak boleh mengubah perilaku aplikasi | Menambahkan konstruktor `const`, docstring, dan komentar di branch `refactor/code-quality`, lalu merapikan format dengan `dart format` | `flutter analyze`, `flutter test`, dan `dart format --set-exit-if-changed` |
| 9. Fitur tambahan | Umpan balik yang lebih jelas saat tombol ditekan | Fitur tambahan harus kecil, relevan, dan tidak mengubah pesan SnackBar yang diwajibkan soal | Mengimplementasikan SnackBar mengambang dengan ikon dan warna tombol di branch `feat/snackbar-feedback` | Test baru yang gagal sebelum fitur dan lolos sesudahnya, ditambah pengecekan visual di ukuran ponsel |

**Analisis kritis keterbatasan AI dan perbaikan manual**
- **AI melewatkan syarat rubrik.** Rencana awal dari AI menyuruh commit langsung ke `main`, padahal rubrik Git & Disiplin menilai *branching* per fitur. Saya menemukan celah ini dan meminta rencana disusun ulang. Pelajaran: output AI harus dicek ulang terhadap rubrik, bukan langsung dipercaya.
- **AI tidak mengetahui kondisi di luar alatnya.** Ketika saya mengira PR sudah di-merge, pengecekan langsung ke GitHub menunjukkan PR belum dibuat. Verifikasi di sumber aslinya (GitHub, `git log`) lebih bisa dipercaya daripada asumsi, baik dari saya maupun dari AI.
- **Kendala teknis pada alat AI.** Pengambilan halaman soal sempat gagal karena *rate limit* (HTTP 429), dan `flutter analyze` yang dijalankan AI sempat macet karena `flutter run` saya masih memegang lock Flutter. AI perlu cara alternatif, yaitu membuka halaman lewat browser dan memakai `dart analyze`.
- **Draf jawaban reflektif tetap harus dipahami sendiri.** Jawaban dari AI saya tinjau dan cocokkan dengan kode saya, misalnya penggunaan `BuildContext` di `menu.dart`, supaya saya bisa menjelaskannya sendiri saat demo.
- **Kerapian detail.** README sempat menyisakan *trailing whitespace* (terdeteksi oleh `git diff --check`) dan bagian analisis ini sempat terhapus saat tabel log diganti. Keduanya saya temukan saat review akhir dan saya perbaiki secara manual.
- **Instruksi AI tidak selalu lengkap.** Pada tahap kualitas kode, AI memperkirakan `dart format` hanya mengubah file test, padahal file `lib` yang saya tempel juga ikut berubah (newline di akhir file). Akibatnya perubahan kecil itu masuk ke commit dokumentasi, bukan ke commit format. Pelajaran: selalu periksa `git status` sebelum dan sesudah commit.

### Tugas 8

**Tools yang digunakan**
- **Claude Code** (model Claude Opus 5.5) di aplikasi desktop Claude.

**Strategi prompting**
- **Pahami rubrik sebelum menulis kode.** AI diminta membaca halaman soal dan rubrik Tugas 8, lalu memeriksa model `Education` dan `Experience` di proyek Django agar field form sesuai model asli.
- **Keputusan desain tetap di tangan saya.** AI memaparkan pilihan bagian portofolio (Education, Experience, Certification) beserta kelebihan dan kekurangannya; saya memilih **Education** karena paling lengkap di proyek Django saya.
- **AI sebagai pemandu, bukan pengeksekusi.** Seperti Tugas 7, AI menulis dan menguji solusi di salinan proyek terpisah, lalu memberikan langkah dan kode di chat. Saya yang menerapkan, menjalankan, membuat commit, dan membuat Pull Request.
- **Verifikasi dengan test, bukan asumsi.** Setiap checklist (akses dari kartu dan drawer, input valid dan tidak valid, kembali ke Home, layar ponsel dengan keyboard) dibuktikan dengan widget test, lalu dicek ulang langsung di aplikasi yang berjalan di Chrome.

**Bagian yang dibantu AI**
- Pemetaan field form ke model `Education` di Django dan aturan validasinya.
- Kode `EducationFormPage`, model `Education`, dan fungsi validasi di `utils/form_validators.dart`.
- Penambahan kartu **Tambah Edukasi** dan opsi **Add Education** di drawer.
- Widget test dan unit test baru.
- Draf jawaban pertanyaan reflektif Tugas 8 yang kemudian saya baca, cocokkan dengan kode, dan pahami.

**Log interaksi AI**

| Tahap | Tujuan | Batasan / instruksi yang saya tetapkan | Keputusan dan tindakan saya | Validasi |
|---|---|---|---|---|
| 1. Analisis tugas | Memahami checklist dan rubrik Tugas 8 secara mendalam | AI hanya membaca soal dan proyek, tanpa mengubah file | Meninjau ringkasan kebutuhan dan hal yang rawan terlewat | Tabel checklist dan rubrik |
| 2. Pemilihan bagian | Menentukan form baru yang sesuai model | Pilihan harus berdasarkan model Django yang sudah ada | Memilih Education setelah membandingkan dengan Experience dan Certification | Pemetaan field form ke field model |
| 3. Implementasi form | Form edukasi dengan validasi sesuai aturan model | Validasi wajib menolak spasi saja, memeriksa panjang, URL, dan urutan tanggal | Mengimplementasikan form, model, dan validator di branch fitur | `flutter analyze` dan unit test validator |
| 4. Navigasi | Akses form dari kartu dan drawer | Opsi Home dan Add Project tetap dipertahankan | Menambahkan kartu dan opsi drawer di branch fitur terpisah | Widget test akses dari kartu, drawer, dan kembali ke Home |
| 5. Pengujian aplikasi | Memastikan alur berjalan di aplikasi sungguhan dan nyaman di ponsel | Tombol Simpan harus terjangkau saat keyboard tampil; AI diminta men-debug sendiri aplikasi yang saya jalankan | Menjalankan `flutter run -d chrome`; AI menguji kartu, tombol Back, drawer, Home, validasi, date picker, dan dialog langsung di aplikasi tersebut | Pengujian manual di Chrome tanpa error di console, ditambah test 320×480, 360×640, 800×360, dan simulasi keyboard |
| 6. Dokumentasi | README Tugas 8 | Jawaban harus merujuk ke kode proyek ini | Meninjau draf jawaban dan AI disclosure | Preview Markdown dan `git diff --check` |

**Analisis kritis keterbatasan AI dan perbaikan**
- **Ada perbedaan antara model Django dan kebutuhan form.** `started_at` di Django diisi otomatis, sedangkan soal meminta `showDatePicker()` dan pemeriksaan urutan tanggal. AI menyoroti perbedaan ini, dan saya memutuskan tetap menambahkan input tanggal mulai serta mencatat alasannya di README. Pelajaran: "sesuai model" perlu ditafsirkan, bukan disalin mentah.
- **Desain awal AI tidak teruji di layar lebar.** Grid dua kolom yang awalnya dipilih AI membuat tombol Logout keluar dari layar 800×600, dan baru ketahuan karena test gagal. Solusinya `GridView.extent` agar jumlah kolom menyesuaikan lebar layar.
- **Overflow yang tidak terlihat di layar desktop.** Test pada ukuran ponsel menemukan dropdown jenjang melebar keluar layar; diperbaiki dengan `isExpanded: true`.
- **Test buatan AI sempat salah, bukan kodenya.** Beberapa test awal gagal karena layar belum diperbarui setelah digulir dan karena field yang masih fokus menggulir layar kembali. Hint "Universitas Indonesia" juga sempat membuat test reset ambigu. Masalah ini diperbaiki di test dan juga mendorong perbaikan UX: tombol Simpan sekarang menutup papan ketik terlebih dahulu.
- **Batas alat AI.** Saat menguji build web rilis, AI sempat gagal mengetik ke field Flutter yang digambar di canvas, dan klik pada mode emulasi ukuran ponsel di browser AI tidak akurat. Karena itu alur isi form pertama kali dibuktikan lewat widget test. Setelah saya menjalankan `flutter run -d chrome`, AI berhasil menguji alur lengkap di aplikasi tersebut, tetapi tampilan ukuran ponsel tetap bergantung pada test otomatis dan pengecekan saya sendiri di Chrome DevTools.
