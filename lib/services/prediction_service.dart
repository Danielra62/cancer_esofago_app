// lib/services/prediction_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class PredictionService {
  final String baseUrl = AppConfig.baseUrl;

  // =============================================
  // SUBIR IMAGEN PARA PREDICCIÓN
  // =============================================
  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/predict'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return jsonDecode(body);
    } else {
      throw Exception("Error en la predicción");
    }
  }

  // =============================================
  // GUARDAR EN HISTORIAL (CORREGIDO)
  // =============================================
  Future<void> savePrediction(
      int userId, String prediction, double confidence) async {
    final url = Uri.parse("$baseUrl/predictions/save");

    print("📤 Enviando datos al backend:");
    print({
      "pacienteId": userId,
      "resultado": prediction,
      "confianza": confidence
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "pacienteId": userId,
        "resultado": prediction,
        "confianza": confidence,
      }),
    );

    print("📥 Respuesta backend historial:");
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception("Error guardando predicción");
    }
  }

  // =============================================
  // OBTENER HISTORIAL
  // =============================================
  Future<List<Map<String, dynamic>>> getHistory(int userId) async {
    final url = Uri.parse("$baseUrl/predicciones/$userId");

    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(resp.body));
    } else {
      throw Exception("Error obteniendo historial");
    }
  }
}
