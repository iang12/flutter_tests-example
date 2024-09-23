import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_search_app/services/github_service.dart';
import 'package:github_search_app/ui/github_search_page.dart';
import 'package:provider/provider.dart';

import 'ui/bloc/github_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => Dio()),
        Provider<GithubService>(
          create: (context) => GithubService(
            Provider.of<Dio>(context, listen: false),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<GithubBloc>(
                create: (context) => GithubBloc(
                  Provider.of<GithubService>(context, listen: false),
                ),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Github Search',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
                useMaterial3: false,
              ),
              home: GithubSearchPage(),
            ),
          );
        },
      ),
    );
  }
}
