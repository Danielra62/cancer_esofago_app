import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    print("===== LOGIN() INICIADO =====");
    print("📩 Email: $email");

    try {
      _loading = true;
      _error = null;
      notifyListeners();

      print("📤 Enviando login al backend...");
      final u = await _authService.login(email, password);
      print("📥 Respuesta del backend: $u");

      if (u == null) {
        print("❌ Backend devolvió usuario NULL");
        throw Exception('Credenciales inválidas');
      }

      _user = u;
      print("👤 Usuario recibido: id=${u.id}, nombre=${u.nombre}, email=${u.email}");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', u.email);
      await prefs.setInt('userId', u.id);
      await prefs.setString('userNombre', u.nombre);

      print("💾 Usuario guardado en SharedPreferences");

      if (u.pacienteId != null) {
        await prefs.setInt('pacienteId', u.pacienteId!);
        print("💾 pacienteId guardado");
      }

      print("===== LOGIN() EXITOSO =====");
      return true;

    } catch (e) {
      print("❌ ERROR EN LOGIN(): $e");
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    print("===== REGISTER() INICIADO =====");
    print("👤 Nombre: $nombre, Email: $email");

    try {
      _loading = true;
      _error = null;
      notifyListeners();

      print("📤 Enviando registro al backend...");
      final u = await _authService.register(nombre, email, password);
      print("📥 Respuesta del backend: $u");

      if (u == null) {
        print("❌ Backend devolvió usuario NULL");
        throw Exception('Error al registrar usuario');
      }

      _user = u;
      print("👤 Usuario creado: id=${u.id}");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', u.email);
      await prefs.setInt('userId', u.id);
      await prefs.setString('userNombre', u.nombre);

      print("💾 Datos guardados en SharedPreferences");

      if (u.pacienteId != null) {
        await prefs.setInt('pacienteId', u.pacienteId!);
        print("💾 pacienteId guardado");
      }

      print("===== REGISTER() EXITOSO =====");
      return true;

    } catch (e) {
      print("❌ ERROR EN REGISTER(): $e");
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    print("===== LOGOUT() =====");
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🗑 SharedPreferences limpiado");
    _user = null;
    notifyListeners();
  }

  Future<void> loadSession() async {
    print("===== loadSession() =====");
    final prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('userEmail');
    final id = prefs.getInt('userId');
    final nombre = prefs.getString('userNombre');
    final pacienteId = prefs.getInt('pacienteId');

    print("📦 Valores recuperados:");
    print("email=$email, id=$id, nombre=$nombre, pacienteId=$pacienteId");

    if (email != null && id != null && nombre != null) {
      _user = User(
        id: id,
        nombre: nombre,
        email: email,
        password: '',
        pacienteId: pacienteId,
      );

      print("👤 Sesión restaurada correctamente: $_user");
      notifyListeners();
    } else {
      print("⚠ No hay datos suficientes para restaurar sesión");
    }
  }
}
