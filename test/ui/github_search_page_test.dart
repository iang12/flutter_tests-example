import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:github_search_app/model/github_model.dart';
import 'package:github_search_app/ui/bloc/github_bloc.dart';
import 'package:github_search_app/ui/bloc/github_event.dart';
import 'package:github_search_app/ui/bloc/github_state.dart';
import 'package:github_search_app/ui/github_search_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

// Mock para o GithubBloc
class MockGithubBloc extends MockBloc<GithubEvent, GithubState>
    implements GithubBloc {}

class FakeApp extends StatelessWidget {
  const FakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Image.network('https://test.com/logo.png'),
        ),
      ),
    );
  }
}

void main() {
  late MockGithubBloc mockGithubBloc;

  setUp(() {
    mockGithubBloc = MockGithubBloc();
  });

  tearDown(() {
    mockGithubBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<GithubBloc>(
        create: (_) => mockGithubBloc,
        child: const GithubSearchPage(),
      ),
    );
  }

  testWidgets(
      'Exibe mensagem inicial quando nenhum termo de busca foi inserido',
      (WidgetTester tester) async {
    when(() => mockGithubBloc.state).thenReturn(GithubInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Enter a search term to begin.'), findsOneWidget);
  });

  testWidgets('Exibe erro se o campo de busca estiver vazio',
      (WidgetTester tester) async {
    when(() => mockGithubBloc.state).thenReturn(GithubInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    // Tenta apertar o botão de pesquisa sem inserir texto
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.text('Please enter some text'), findsOneWidget);
  });

  testWidgets('Exibe o carregamento quando o GithubLoading é emitido',
      (WidgetTester tester) async {
    when(() => mockGithubBloc.state).thenReturn(GithubLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Exibe os repositórios carregados quando GithubLoaded é emitido',
      (WidgetTester tester) async {
    await mockNetworkImages(() async => tester.pumpWidget(const FakeApp()));
    final mockRepositories = [
      GithubModel(
        name: 'flutter',
        stars: '100000',
        avatar: 'https://avatars.githubusercontent.com/u/14101776?v=4',
      ),
    ];

    when(() => mockGithubBloc.state).thenReturn(GithubLoaded(mockRepositories));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('flutter'), findsOneWidget);
    expect(find.text('100000 stars'), findsOneWidget);
  });

  testWidgets('Exibe a mensagem de erro quando GithubError é emitido',
      (WidgetTester tester) async {
    when(() => mockGithubBloc.state)
        .thenReturn(const GithubError('Erro na busca'));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Error: Erro na busca'), findsOneWidget);
  });

  testWidgets('Dispara o evento de busca quando o botão de pesquisa é clicado',
      (WidgetTester tester) async {
    when(() => mockGithubBloc.state).thenReturn(GithubInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(find.byType(TextFormField), 'flutter');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    verify(() => mockGithubBloc.add(const SearchRepositories('flutter')))
        .called(1);
  });
}
