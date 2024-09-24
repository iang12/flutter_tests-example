import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:github_search_app/model/github_model.dart';
import 'package:github_search_app/services/github_service.dart';

import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late GithubService githubService;

  setUp(() {
    dio = MockDio();
    githubService = GithubService(dio);
  });
  final responseJsonMock = {
    'items': [
      {
        'name': 'flutter',
        'description':
            'Google’s UI toolkit for building natively compiled applications.',
        'html_url': 'https://github.com/flutter/flutter',
        'language': 'Dart',
        'stargazers_count': 123456,
        'forks_count': 7890,
        'watchers_count': 123456,
        'created_at': '2015-03-06T22:54:58Z',
        'updated_at': '2023-08-08T11:29:27Z',
        'pushed_at': '2023-08-08T10:29:27Z',
        'license': {'name': 'BSD-3-Clause'},
        'homepage': 'https://flutter.dev',
        "owner": {
          "login": "flutter",
          "id": 14101776,
          "node_id": "MDEyOk9yZ2FuaXphdGlvbjE0MTAxNzc2",
          "avatar_url": "https://avatars.githubusercontent.com/u/14101776?v=4"
        }
      },
    ]
  };
  group('GithubService - searchRepositories', () {
    test('Deve retornar uma lista de GithubModel em caso de sucesso', () async {
      // Mock da requisição GET
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: responseJsonMock,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // Chamada do serviço
      final result = await githubService.searchRepositories('flutter');

      // Verificação
      expect(result, isA<List<GithubModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'flutter');
      verify(() =>
              dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .called(1);
    });

    test('Deve lançar uma exceção se a resposta for 404', () async {
      // Mock da resposta de erro
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => Response(
          data: 'Not Found',
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
      );

      // Chamada do serviço e verificação da exceção
      expect(
        () async => await githubService.searchRepositories('unknown_repo'),
        throwsException,
      );

      verify(() =>
              dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .called(1);
    });

    test('Deve lançar uma exceção em caso de erro de rede', () async {
      // Mock de uma exceção de rede
      when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          error: 'Network Error',
        ),
      );

      // Chamada do serviço e verificação da exceção
      expect(
        () async => await githubService.searchRepositories('flutter'),
        throwsException,
      );

      verify(() =>
              dio.get(any(), queryParameters: any(named: 'queryParameters')))
          .called(1);
    });
  });
}
