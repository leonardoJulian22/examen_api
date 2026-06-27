class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final Location location;
  final List<String> episode;
  final String gender;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.location,
    required this.episode,
    required this.gender,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      location: Location.fromJson(json['location']),
      episode: List<String>.from(json['episode']),
      gender: json['gender'],
    );
  }
}

class Location {
  final String name;
  final String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'], url: json['url']);
  }
}
