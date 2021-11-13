class PopMovie {
  final int id;
  String title;
  String homepage;
  String overview;
  String release_date;
  int runtime;
  final String vote_average;
  final List genres;
  final List persons;

  PopMovie(
      {
        required this.id,
        required this.title,
        required this.homepage,
        required this.overview,
        required this.release_date,
        required this.runtime,
        required this.vote_average,
        required this.genres,
        required this.persons,
      });
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
        id: json['movie_id'],
        title: json['title'],
        homepage: json['homepage'],
        overview: json['overview'],
        release_date: json['release_date'],
        runtime: json['runtime'],
        vote_average: json['vote_average'],
        genres: json['genres'],
        persons: json['persons'],);
  }
}

List<PopMovie> PMs = [];