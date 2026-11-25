import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Exception yang dilempar ketika request API mengembalikan status non-2xx.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  /// Kode status HTTP dari server, misalnya 400, 401, atau 403.
  final int statusCode;

  /// Body response mentah dari server.
  final String message;

  /// Pesan yang ramah pengguna berdasarkan [statusCode], tanpa menampilkan
  /// body mentah (yang bisa berisi halaman error HTML dari server).
  String get userMessage => switch (statusCode) {
    400 => 'Data tidak valid ($statusCode).',
    401 => 'Sesi tidak valid, silakan login kembali ($statusCode).',
    403 => 'Akun ini tidak memiliki izin untuk aksi tersebut ($statusCode).',
    404 => 'Data tidak ditemukan ($statusCode).',
    >= 500 => 'Server sedang bermasalah ($statusCode).',
    _ => 'Permintaan gagal ($statusCode).',
  };

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Klien HTTP untuk backend Django REST Framework MyPortfolio.
///
/// Semua logika jaringan dikumpulkan di sini agar screen dan widget hanya
/// fokus menampilkan antarmuka. Header ditulis sebagai string biasa (bukan
/// `HttpHeaders` dari `dart:io`) agar tetap berjalan di Flutter Web.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;

  /// Alamat dasar backend, misalnya `http://localhost:8000`.
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Mengambil seluruh proyek (endpoint publik, tanpa token).
  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Membuat proyek baru; membutuhkan token milik superuser.
  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Project.fromJson(decoded);
  }

  /// Menukar username dan password dengan token autentikasi.
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  /// Mencabut token saat ini di server (response 204 No Content).
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {'Accept': 'application/json', 'Authorization': 'Token $token'},
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}
