class GithubModel {
  String? name;
  String? description;
  String? url;
  String? language;
  String? stars;
  String? forks;
  String? watchers;
  String? createdAt;
  String? updatedAt;
  String? pushedAt;
  String? license;
  String? homepage;
  String? topics;
  String? avatar;

  GithubModel({
    this.name,
    this.description,
    this.url,
    this.language,
    this.stars,
    this.forks,
    this.watchers,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.license,
    this.homepage,
    this.avatar,
  });

  factory GithubModel.fromJson(Map<String, dynamic> json) {
    return GithubModel(
      name: json['name'],
      description: json['description'],
      url: json['html_url'],
      language: json['language'],
      stars: json['stargazers_count'].toString(),
      forks: json['forks_count'].toString(),
      watchers: json['watchers_count'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pushedAt: json['pushed_at'],
      license: json['license'] != null ? json['license']['name'] : null,
      homepage: json['homepage'],
      avatar: json['owner']['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'language': language,
      'stars': stars,
      'forks': forks,
      'watchers': watchers,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pushed_at': pushedAt,
      'license': license,
      'homepage': homepage,
    };
  }

  static List<GithubModel> parseGithubList(List<dynamic> jsonList) {
    return jsonList
        .map<GithubModel>((json) => GithubModel.fromJson(json))
        .toList();
  }
}
