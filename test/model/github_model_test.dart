import 'package:flutter_test/flutter_test.dart';
import 'package:github_search_app/model/github_model.dart';

void main() {
  group('GithubModel', () {
    final jsonMock = {
      'name': 'flutter',
      'description': 'A framework for building cross-platform apps',
      'html_url': 'https://github.com/flutter/flutter',
      'language': 'Dart',
      'stargazers_count': 100000,
      'forks_count': 15000,
      'watchers_count': 100000,
      'created_at': '2015-03-06T22:31:18Z',
      'updated_at': '2023-09-23T12:45:00Z',
      'pushed_at': '2023-09-23T12:45:00Z',
      'license': {'name': 'BSD-3-Clause'},
      'homepage': 'https://flutter.dev',
      'owner': {
        'avatar_url': 'https://avatars.githubusercontent.com/u/14101776?v=4'
      },
    };

    test('fromJson deve criar uma instância de GithubModel a partir de um JSON',
        () {
      final githubModel = GithubModel.fromJson(jsonMock);

      expect(githubModel.name, 'flutter');
      expect(githubModel.description,
          'A framework for building cross-platform apps');
      expect(githubModel.url, 'https://github.com/flutter/flutter');
      expect(githubModel.language, 'Dart');
      expect(githubModel.stars, '100000');
      expect(githubModel.forks, '15000');
      expect(githubModel.watchers, '100000');
      expect(githubModel.createdAt, '2015-03-06T22:31:18Z');
      expect(githubModel.updatedAt, '2023-09-23T12:45:00Z');
      expect(githubModel.pushedAt, '2023-09-23T12:45:00Z');
      expect(githubModel.license, 'BSD-3-Clause');
      expect(githubModel.homepage, 'https://flutter.dev');
      expect(githubModel.avatar,
          'https://avatars.githubusercontent.com/u/14101776?v=4');
    });

    test('toJson deve converter uma instância de GithubModel para um JSON', () {
      final githubModel = GithubModel.fromJson(jsonMock);
      final json = githubModel.toJson();

      expect(json['name'], 'flutter');
      expect(
          json['description'], 'A framework for building cross-platform apps');
      expect(json['url'], 'https://github.com/flutter/flutter');
      expect(json['language'], 'Dart');
      expect(json['stars'], '100000');
      expect(json['forks'], '15000');
      expect(json['watchers'], '100000');
      expect(json['created_at'], '2015-03-06T22:31:18Z');
      expect(json['updated_at'], '2023-09-23T12:45:00Z');
      expect(json['pushed_at'], '2023-09-23T12:45:00Z');
      expect(json['license'], 'BSD-3-Clause');
      expect(json['homepage'], 'https://flutter.dev');
    });

    test(
        'parseGithubList deve converter uma lista de JSON em uma lista de GithubModel',
        () {
      final jsonList = [jsonMock, jsonMock];
      final githubList = GithubModel.parseGithubList(jsonList);

      expect(githubList.length, 2);
      expect(githubList.first.name, 'flutter');
      expect(githubList.first.stars, '100000');
    });
  });
}
