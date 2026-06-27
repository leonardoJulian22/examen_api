import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_rick_morty.dart';
import '../widgets/character_detail_modal.dart';

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  final List<Character> _characters = [];
  int _currentPage = 0;
  int _totalPages = 1;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadNextPage();
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || _currentPage >= _totalPages) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.getCharactersPage(_currentPage + 1);

      if (!mounted) return;

      setState(() {
        _characters.addAll(response.characters);
        _currentPage = response.currentPage;
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Error al cargar personajes';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rick and Morty Personajes'),
        backgroundColor: Colors.green[700],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_characters.isEmpty && _isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_characters.isEmpty && _errorMessage != null) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _loadNextPage,
          icon: Icon(Icons.refresh),
          label: Text(_errorMessage!),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _characters.length + 1,
      itemBuilder: (context, index) {
        if (index == _characters.length) {
          if (_isLoading) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (_errorMessage != null) {
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: _loadNextPage,
                  icon: Icon(Icons.refresh),
                  label: Text('Reintentar'),
                ),
              ),
            );
          }

          return SizedBox.shrink();
        }

        final character = _characters[index];
        return CharacterCard(
          character: character,
          onTap: () => _showCharacterModal(context, character),
        );
      },
    );
  }

  void _showCharacterModal(BuildContext context, Character character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterDetailModal(character: character),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            character.image,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(child: Icon(Icons.person));
            },
          ),
        ),
        title: Text(
          character.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${character.species} - ${character.status}'),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
