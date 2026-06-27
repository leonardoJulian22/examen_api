import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const Duration _requestTimeout = Duration(seconds: 20);

  // Obtener todos los personajes
  Future<List<Character>> getCharacters() async {
    final allCharacters = <Character>[];
    var page = 1;
    var totalPages = 1;

    do {
      final response = await getCharactersPage(page);
      allCharacters.addAll(response.characters);
      totalPages = response.totalPages;
      page++;
    } while (page <= totalPages);

    return allCharacters;
  }

  Future<CharacterPage> getCharactersPage(int page) async {
    final data = await _getJson('$baseUrl/character?page=$page');
    final info = data['info'] as Map<String, dynamic>;

    return CharacterPage(
      characters: _parseCharacters(data),
      currentPage: page,
      totalPages: info['pages'] as int,
      hasNextPage: info['next'] != null,
    );
  }

  Future<List<Character>> getCharactersPages(int fromPage, int toPage) async {
    final characters = <Character>[];

    for (var page = fromPage; page <= toPage; page++) {
      final response = await getCharactersPage(page);
      characters.addAll(response.characters);
    }

    return characters;
  }

  // Obtener episodios por URLs
  Future<List<Episode>> getEpisodesByUrls(List<String> episodeUrls) async {
    // Tomamos solo los primeros 5 episodios para no sobrecargar
    final episodes = await Future.wait(episodeUrls.take(5).map(_getJson));
    return episodes.map((json) => Episode.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    const maxAttempts = 2;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(_requestTimeout);

        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        }

        if (response.statusCode == 429) {
          await Future.delayed(Duration(seconds: attempt));
        }

        throw Exception('Respuesta ${response.statusCode}');
      } catch (error) {
        if (attempt == maxAttempts) {
          throw Exception('Error al cargar datos: $error');
        }
      }
    }

    throw Exception('Error al cargar datos');
  }

  List<Character> _parseCharacters(Map<String, dynamic> data) {
    final results = data['results'] as List<dynamic>;
    return results
        .map((json) => Character.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class CharacterPage {
  final List<Character> characters;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  CharacterPage({
    required this.characters,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}
