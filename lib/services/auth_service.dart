import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {

  final String baseUrl = "https://danielacr-bve7fwfeccg4brg2.brazilsouth-01.azurewebsites.net";

  // ---------------- LOGIN ----------------
  Future<User?> login(String  email, String password) async {
    final uri = Uri.parse('$baseUrl/users/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    } else if (res.statusCode == 401) {
      throw Exception("Contraseña incorrecta");
    } else if (res.statusCode == 404) {
      throw Exception("Usuario no encontrado");
    } else {
      throw Exception('Error al iniciar sesión: ${res.statusCode}');
    }
  }

  // ---------------- REGISTER ----------------
  Future<User?> register(String nombre, String email, String password) async {
    final uri = Uri.parse('$baseUrl/users');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "nombre": nombre.trim(),
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    } else if (res.statusCode == 400) {
      throw Exception("El correo ya está registrado");
    } else {
      throw Exception('Error al registrar usuario: ${res.statusCode}');
    }
  }
}
