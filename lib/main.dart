import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Titik masuk aplikasi MyPortfolio Mobile.
void main() {
  runApp(MyApp(apiClient: ApiClient()));
}

/// Root widget aplikasi.
///
/// Menyediakan [ApiClient] dan [AuthState] ke seluruh widget tree melalui
/// [MultiProvider], serta [MaterialApp] beserta tema global sehingga seluruh
/// widget di bawahnya dapat mengakses [Theme], [MediaQuery], dan
/// [ScaffoldMessenger].
class MyApp extends StatelessWidget {
  const MyApp({required this.apiClient, this.initialToken, super.key});

  /// Klien HTTP yang dipakai bersama oleh semua halaman.
  final ApiClient apiClient;

  /// Token awal (opsional), misalnya untuk pengujian dalam kondisi login.
  final String? initialToken;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: apiClient),
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(apiClient, initialToken: initialToken),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
