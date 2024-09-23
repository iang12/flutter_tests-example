import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_search_app/model/github_model.dart';
import 'package:github_search_app/services/github_service.dart';
import 'package:github_search_app/ui/bloc/github_bloc.dart';
import 'package:github_search_app/ui/bloc/github_event.dart';
import 'package:github_search_app/ui/bloc/github_state.dart';

import 'package:mocktail/mocktail.dart';

class MockGithubService extends Mock implements GithubService {}

void main() {
  late MockGithubService mockGithubService;
  late GithubBloc githubBloc;

  setUp(() {
    mockGithubService = MockGithubService();
    githubBloc = GithubBloc(mockGithubService);
  });

  tearDown(() {
    githubBloc.close();
  });

  group('GithubBloc - searchRepositories', () {
    final List<GithubModel> mockRepositories = [
      GithubModel(
        name: 'flutter',
        avatar: 'flutter',
      ),
    ];

    test('O estado inicial deve ser GithubInitial', () {
      expect(githubBloc.state, GithubInitial());
    });

    blocTest<GithubBloc, GithubState>(
      'Deve emitir [GithubLoading, GithubLoaded] quando searchRepositories for bem-sucedido',
      build: () {
        when(() => mockGithubService.searchRepositories('flutter'))
            .thenAnswer((_) async => mockRepositories);
        return githubBloc;
      },
      act: (bloc) => bloc.add(const SearchRepositories('flutter')),
      expect: () => [
        GithubLoading(),
        GithubLoaded(mockRepositories),
      ],
      verify: (_) {
        verify(() => mockGithubService.searchRepositories('flutter')).called(1);
      },
    );

    blocTest<GithubBloc, GithubState>(
      'Deve emitir [GithubLoading, GithubError] quando searchRepositories falhar',
      build: () {
        when(() => mockGithubService.searchRepositories('flutter'))
            .thenThrow(Exception('Erro na busca'));
        return githubBloc;
      },
      act: (bloc) => bloc.add(const SearchRepositories('flutter')),
      expect: () => [
        GithubLoading(),
        isA<GithubError>(),
      ],
      verify: (_) {
        verify(() => mockGithubService.searchRepositories('flutter')).called(1);
      },
    );
  });
}
