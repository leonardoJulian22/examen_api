import 'package:flutter/material.dart';
import 'screens/main_menu_screen.dart'; // <-- 1. Importamos tu nuevo menú aquí

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // <-- 2. Esto arregla la advertencia de la línea 7

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenuScreen(), // <-- 3. ¡Aquí conectamos el menú con las dos pestañas!
    );
  }
}