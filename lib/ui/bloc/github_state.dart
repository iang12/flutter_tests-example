import 'package:equatable/equatable.dart';
import '../../model/github_model.dart';

abstract class GithubState extends Equatable {
  const GithubState();

  @override
  List<Object?> get props => [];
}

class GithubInitial extends GithubState {}

class GithubLoading extends GithubState {}

class GithubLoaded extends GithubState {
  final List<GithubModel> repositories;

  const GithubLoaded(this.repositories);

  @override
  List<Object?> get props => [repositories];
}

class GithubError extends GithubState {
  final String message;

  const GithubError(this.message);

  @override
  List<Object?> get props => [message];
}
