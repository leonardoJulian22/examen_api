import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/episode.dart';
import '../services/api_rick_morty.dart';

class CharacterDetailModal extends StatefulWidget {
  final Character character;

  const CharacterDetailModal({required this.character});

  @override
  _CharacterDetailModalState createState() => _CharacterDetailModalState();
}

class _CharacterDetailModalState extends State<CharacterDetailModal> {
  final ApiService _apiService = ApiService();
  late Future<List<Episode>> _episodesFuture;

  @override
  void initState() {
    super.initState();
    _episodesFuture = _apiService.getEpisodesByUrls(widget.character.episode);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Handle para arrastrar
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Imagen del personaje
                Hero(
                  tag: 'character_${widget.character.id}',
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(widget.character.image),
                  ),
                ),
                SizedBox(height: 16),

                // Información básica
                Text(
                  widget.character.name,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '${widget.character.species} • ${widget.character.status} • ${widget.character.gender}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 24),

                // Ubicación
                _buildLocationSection(),

                SizedBox(height: 24),

                // Episodios
                _buildEpisodesSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[700]),
              SizedBox(width: 8),
              Text(
                'Ubicación Actual',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(widget.character.location.name, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEpisodesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tv, color: Colors.green[700]),
              SizedBox(width: 8),
              Text(
                'Episodios donde aparece',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Total de episodios: ${widget.character.episode.length}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          FutureBuilder<List<Episode>>(
            future: _episodesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error al cargar episodios');
              }

              final episodes = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  final episode = episodes[index];
                  return ListTile(
                    leading: Icon(Icons.play_circle_fill, color: Colors.green),
                    title: Text(episode.name),
                    subtitle: Text('${episode.episode} • ${episode.airDate}'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
