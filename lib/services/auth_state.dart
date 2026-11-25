import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

/// Menyimpan token autentikasi sesi saat ini di memori.
///
/// Turunan [ChangeNotifier] sehingga widget yang memakai
/// `context.watch<AuthState>()` otomatis dibangun ulang saat login/logout.
class AuthState extends ChangeNotifier {
  AuthState(this._apiClient, {String? initialToken}) : _token = initialToken;

  final ApiClient _apiClient;
  String? _token;

  /// Token aktif, atau `null` jika belum login.
  String? get token => _token;

  /// `true` jika pengguna sudah login.
  bool get isLoggedIn => _token != null;

  /// Login ke backend dan menyimpan token yang diterima.
  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  /// Logout dari backend lalu menghapus token lokal.
  ///
  /// Token lokal selalu dihapus walaupun request ke server gagal, agar
  /// pengguna tidak terjebak dalam sesi yang tokennya sudah tidak valid.
  Future<void> logout() async {
    final current = _token;
    if (current == null) return;

    try {
      await _apiClient.logout(token: current);
    } on ApiException {
      // Token mungkin sudah dicabut atau kedaluwarsa di server; abaikan.
    } finally {
      _token = null;
      notifyListeners();
    }
  }
}
