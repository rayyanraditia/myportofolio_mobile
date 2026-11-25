import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'helpers/fake_backend.dart';

void main() {
  test('Project memetakan JSON snake_case dan tidak mengirim id', () {
    final project = Project.fromJson(sampleProject());

    expect(project.id, 'p1');
    expect(project.techStack, 'Django, Tailwind');
    expect(project.toJson().containsKey('id'), isFalse);
    expect(project.toJson()['tech_stack'], 'Django, Tailwind');
  });

  test('project_image_url null menjadi string kosong', () {
    final json = sampleProject()..['project_image_url'] = null;
    expect(Project.fromJson(json).projectImageUrl, '');
  });

  test('obtainToken mengembalikan token dan logout mengirim header', () async {
    final backend = FakeBackend();

    final token = await backend.apiClient.obtainToken('owner', 'secret');
    await backend.apiClient.logout(token: token);

    expect(token, validToken);
    expect(backend.requests.last.headers['Authorization'], 'Token $validToken');
  });

  test('Status non-2xx dilempar sebagai ApiException', () async {
    final backend = FakeBackend(listStatus: 503);

    expect(
      backend.apiClient.getProjects(),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 503),
      ),
    );
  });
}
