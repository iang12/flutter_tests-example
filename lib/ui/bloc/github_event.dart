import 'package:equatable/equatable.dart';

abstract class GithubEvent extends Equatable {
  const GithubEvent();

  @override
  List<Object?> get props => [];
}

class SearchRepositories extends GithubEvent {
  final String query;

  const SearchRepositories(this.query);

  @override
  List<Object?> get props => [query];
}
