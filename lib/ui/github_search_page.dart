import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/github_model.dart';
import 'bloc/github_bloc.dart';
import 'bloc/github_event.dart';
import 'bloc/github_state.dart';

class GithubSearchPage extends StatefulWidget {
  const GithubSearchPage({super.key});

  @override
  State<GithubSearchPage> createState() => _GithubSearchPageState();
}

class _GithubSearchPageState extends State<GithubSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Repository Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Search repositories...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<GithubBloc>(context).add(
                          SearchRepositories(_controller.text),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<GithubBloc, GithubState>(
                  builder: (context, state) {
                    if (state is GithubLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GithubLoaded) {
                      return ListRepositoriesWidget(
                        repositories: state.repositories,
                      );
                    } else if (state is GithubError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                        child: Text('Enter a search term to begin.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListRepositoriesWidget extends StatelessWidget {
  const ListRepositoriesWidget({
    super.key,
    required this.repositories,
  });

  final List<GithubModel> repositories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        return ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(repo.avatar!),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  repo.name ?? 'N/A',
                  style: const TextStyle(
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          trailing: Text('${repo.stars} stars'),
        );
      },
    );
  }
}
