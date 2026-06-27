import 'package:flutter/material.dart';
import 'character_list_screen.dart';
import 'user_list_screen.dart'; // Tu pantalla de usuarios

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  // Aquí ponemos las dos pantallas que creaste
final List<Widget> _pantallas = [
    CharacterListScreen(), // <-- Le quitamos el "const"
    UserListScreen(),      // <-- Le quitamos el "const"
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star), // Icono para Rick y Morty
            label: 'Rick & Morty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people), // Icono para tus Usuarios
            label: 'Usuarios',
          ),
        ],
      ),
    );
  }
}