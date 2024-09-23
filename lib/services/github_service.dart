import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../model/github_model.dart';

class GithubService {
  final Dio dio;
  GithubService(this.dio);
  final baseURL = 'https://api.github.com/search/repositories?q=';

  var logger = Logger();
  Future<List<GithubModel>> searchRepositories(String query) async {
    try {
      final response = await dio.get(baseURL, queryParameters: {
        'q': query,
        'page': 1,
        'per_page': 50,
      });

      if (response.statusCode == 200) {
        return GithubModel.parseGithubList(response.data['items']);
      } else {
        throw Exception('Failed to load data ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to FETCH DATA $e');
    }
  }
}
