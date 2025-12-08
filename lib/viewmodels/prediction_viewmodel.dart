// lib/viewmodels/prediction_viewmodel.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/prediction_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/prediction_history.dart';

class PredictionViewModel extends ChangeNotifier {
  final PredictionService _service = PredictionService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? prediction;
  double? confidence;
  String? errorMessage;

  // -------------------------------------------
  //              PREDICT
  // -------------------------------------------

  Future<void> predict(File image, BuildContext context) async {
    print("===== PREDICT() =====");

    _isLoading = true;
    notifyListeners();

    try {
      print("📤 Subiendo imagen...");
      final result = await _service.uploadImage(image);

      print("📥 Respuesta backend: $result");

      prediction = result["resultado"] ?? result["prediction"];
      confidence = (result["confianza"] ?? result["confidence"])?.toDouble();

      print("🔎 prediction: $prediction");
      print("🔎 confidence: $confidence");

      final auth = Provider.of<AuthViewModel>(context, listen: false);

      if (auth.user == null) {
        print("❌ Usuario no autenticado");
        throw Exception("Usuario no autenticado");
      }

      if (prediction == null || confidence == null) {
        print("❌ Backend devolvió datos inválidos");
        throw Exception("Valores nulos en la respuesta del backend");
      }

      print("💾 Guardando historial...");
      await _service.savePrediction(
        auth.user!.id,
        prediction!,
        confidence!,
      );

      print("✅ Historial guardado");

    } catch (e) {
      errorMessage = e.toString();
      print("❌ ERROR: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // -------------------------------------------
  //              HISTORIAL
  // -------------------------------------------

  List<PredictionHistory> history = [];

  Future<void> loadHistory(BuildContext context) async {
    print("===== loadHistory() =====");

    try {
      final auth = Provider.of<AuthViewModel>(context, listen: false);

      if (auth.user == null) {
        print("❌ Usuario no autenticado");
        throw Exception("Usuario no autenticado");
      }

      print("📥 Pidiendo historial al backend...");
      final rawList = await _service.getHistory(auth.user!.id);

      print("📄 Respuesta backend: $rawList");

      // Convertir Map → Modelo PredictionHistory
      history = rawList
          .map<PredictionHistory>((json) => PredictionHistory.fromJson(json))
          .toList();

      print("📄 Historial parseado (modelo): $history");

      notifyListeners();

    } catch (e) {
      errorMessage = e.toString();
      print("❌ ERROR loadHistory(): $e");
      notifyListeners();
    }
  }

  // -------------------------------------------
  //              CLEAR
  // -------------------------------------------

  void clear() {
    prediction = null;
    confidence = null;
    errorMessage = null;
    notifyListeners();
  }
}
