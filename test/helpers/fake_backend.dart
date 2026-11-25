import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// Token yang dianggap valid oleh [FakeBackend].
const validToken = 'valid-token';

/// Backend Django palsu untuk pengujian, dibangun dengan `MockClient` dari
/// `package:http/testing.dart` sehingga test tidak butuh server sungguhan.
class FakeBackend {
  FakeBackend({
    List<Map<String, dynamic>>? projects,
    this.listStatus = 200,
    this.createStatus = 201,
    this.password = 'secret',
  }) : projects = projects ?? [];

  /// Data proyek yang dikembalikan oleh `GET /api/v1/projects/`.
  final List<Map<String, dynamic>> projects;

  /// Status untuk `GET /api/v1/projects/` (ubah untuk mensimulasikan error).
  int listStatus;

  /// Status untuk `POST /api/v1/projects/` jika token valid.
  int createStatus;

  /// Password yang diterima oleh endpoint token.
  final String password;

  /// Semua request yang diterima, untuk diperiksa di test.
  final List<http.Request> requests = [];

  late final ApiClient apiClient = ApiClient(
    client: MockClient(_handle),
    baseUrl: 'http://backend.test',
  );

  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    final path = request.url.path;
    final authorized = request.headers['Authorization'] == 'Token $validToken';

    if (path == '/api/v1/projects/' && request.method == 'GET') {
      return http.Response(jsonEncode(projects), listStatus);
    }
    if (path == '/api/v1/projects/' && request.method == 'POST') {
      if (!authorized) return http.Response('{"detail":"Invalid token."}', 401);
      if (createStatus != 201) return http.Response('{}', createStatus);
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      final created = {'id': 'new-id', ...body};
      projects.add(created);
      return http.Response(jsonEncode(created), 201);
    }
    if (path == '/api/v1/auth/token/' && request.method == 'POST') {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      if (body['password'] == password) {
        return http.Response(jsonEncode({'token': validToken}), 200);
      }
      return http.Response('{"non_field_errors":["Unable to log in"]}', 400);
    }
    if (path == '/api/v1/auth/logout/' && request.method == 'POST') {
      return http.Response('', authorized ? 204 : 401);
    }
    return http.Response('Not found', 404);
  }
}

/// Aplikasi lengkap ([MyApp]) yang terhubung ke [backend].
Widget buildTestApp(FakeBackend backend, {String? token}) {
  return MyApp(apiClient: backend.apiClient, initialToken: token);
}

/// Membungkus satu halaman dengan provider yang sama seperti [MyApp].
Widget wrapWithProviders(Widget child, FakeBackend backend, {String? token}) {
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: backend.apiClient),
      ChangeNotifierProvider<AuthState>(
        create: (_) => AuthState(backend.apiClient, initialToken: token),
      ),
    ],
    child: MaterialApp(home: child),
  );
}

/// Contoh data proyek dalam format JSON dari Django.
Map<String, dynamic> sampleProject({
  String id = 'p1',
  String title = 'Portfolio Website',
  String imageUrl = '',
}) {
  return {
    'id': id,
    'title': title,
    'description': 'Website portofolio pribadi',
    'tech_stack': 'Django, Tailwind',
    'project_url': 'https://github.com/example/portfolio',
    'project_image_url': imageUrl,
    'star_count': 0,
    'is_starred': false,
    'starred_by_names': '',
  };
}
