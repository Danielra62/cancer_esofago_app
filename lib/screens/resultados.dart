import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/prediction_viewmodel.dart';

class ResultsScreen extends StatelessWidget {
  static const routeName = '/results';
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PredictionViewModel>(context);

    // Obtener última predicción REAL
    final last = vm.history.isNotEmpty ? vm.history.last : null;

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.cyan.shade300,
        foregroundColor: Colors.white,
      ),
      body: last == null
          ? const Center(
        child: Text(
          "No existe una predicción previa",
          style: TextStyle(fontSize: 20),
        ),
      )
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Resultado del análisis',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // ===============================
                  // CÍRCULO CON PORCENTAJE REAL
                  // ===============================
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: last.confianza / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _circleColor(last),
                          ),
                        ),
                      ),
                      Text(
                        "${last.confianza.floor()}%",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    _riskLabel(last),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _circleColor(last),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===============================
                  // INFORMACIÓN ADICIONAL
                  // ===============================
                  Text(
                    last.resultado.contains("no-esophagus")
                        ? "Sin cáncer"
                        : "Con cáncer",
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Fecha: ${last.fecha}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  if (_extraMessage(last) != null)
                    Text(
                      _extraMessage(last)!,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black54),
                    ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.cyan.shade300,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/home');
                      },
                      child: const Text('Volver al menú'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================================================
  // LÓGICA DE COLORES DEL CÍRCULO
  // ========================================================
  Color _circleColor(item) {
    final conf = item.confianza;
    final noCancer = item.resultado.contains("no-esophagus");
    final cancer = item.resultado.contains("esophagus") &&
        !item.resultado.contains("no-esophagus");

    if (noCancer) {
      if (conf > 90) return Colors.green;
      if (conf > 75) return Colors.orange;
      return Colors.red;
    }

    if (cancer) {
      if (conf > 90) return Colors.red;
      if (conf > 75) return Colors.orange;
      return Colors.green;
    }

    return Colors.grey;
  }

  // ========================================================
  // TEXTO DE NIVEL DE RIESGO
  // ========================================================
  String _riskLabel(item) {
    if (item.resultado.contains("no-esophagus")) {
      if (item.confianza > 90) return "Riesgo muy bajo";
      if (item.confianza > 75) return "Riesgo bajo";
      return "Riesgo moderado";
    } else {
      if (item.confianza > 90) return "Riesgo muy alto";
      if (item.confianza > 75) return "Riesgo alto";
      return "Riesgo moderado";
    }
  }

  // ========================================================
  // MENSAJE EXTRA OPCIONAL
  // ========================================================
  String? _extraMessage(item) {
    if (item.resultado.contains("no-esophagus") && item.confianza > 90) {
      return "Todo parece estar bien";
    }
    if (item.resultado.contains("esophagus") && item.confianza > 90) {
      return "Debes ir con un doctor urgentemente";
    }
    return null;
  }
}
