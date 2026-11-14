import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';

/// Titik masuk aplikasi MyPortfolio Mobile.
void main() {
  runApp(const MyApp());
}

/// Root widget aplikasi.
///
/// Menyediakan [MaterialApp] beserta tema global sehingga seluruh widget di
/// bawahnya dapat mengakses [Theme], [MediaQuery], dan [ScaffoldMessenger].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        // Skema warna dibangkitkan dari satu warna dasar (seed) agar
        // warna-warna turunan Material 3 tetap serasi.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}