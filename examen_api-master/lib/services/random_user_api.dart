import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class RandomUserApi {
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('https://randomuser.me/api/?results=100'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List users = data['results'];

      return users.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }
}