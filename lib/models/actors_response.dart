import 'dart:convert';

class ActorsResponse {
    int id;
    List<Cast> cast;
    List<Cast> crew;

    ActorsResponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    factory ActorsResponse.fromRawJson(String str) => ActorsResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ActorsResponse.fromJson(Map<String, dynamic> json) => ActorsResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
    };
}

class Cast {
    bool adult;
    int gender;
    int id;
    String knownForDepartment;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    int? castId;
    String? character;
    String creditId;
    int? order;
    String? department;
    String? job;

    Cast({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        required this.profilePath,
        this.castId,
        this.character,
        required this.creditId,
        this.order,
        this.department,
        this.job,
    });

    static List<Cast> placeholder() {

      List<Cast> actors = [];

      for (var i = 0; i < 10; i++) {
        actors.add(Cast(adult: false, gender: 0, id: 0, knownForDepartment: "", name: "", originalName: "", popularity: 0, profilePath: "", creditId: ""));
      }

      return actors;
    }

    factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: json["department"],
        job: json["job"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job,
    };

  get fullPosterPath => profilePath != null ? "https://image.tmdb.org/t/p/w500/$profilePath" : "";

  @override
  String toString() {
    return "Cast{id: $id, name: $name, originalName: $originalName, fullPosterPath: $fullPosterPath}";
  }
}
