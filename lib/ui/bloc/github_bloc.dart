import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/github_service.dart';
import 'github_event.dart';
import 'github_state.dart';

class GithubBloc extends Bloc<GithubEvent, GithubState> {
  final GithubService githubService;

  GithubBloc(this.githubService) : super(GithubInitial()) {
    on<SearchRepositories>((event, emit) async {
      emit(GithubLoading());
      try {
        final repositories = await githubService.searchRepositories(
          event.query,
        );
        emit(GithubLoaded(repositories));
      } catch (e) {
        emit(GithubError(e.toString()));
      }
    });
  }
}
