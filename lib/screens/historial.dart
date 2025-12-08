import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/prediction_viewmodel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    // Cargar historial al iniciar la pantalla
    Future.microtask(() {
      Provider.of<PredictionViewModel>(context, listen: false)
          .loadHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PredictionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Predicciones"),
      ),
      body: vm.history.isEmpty
          ? const Center(child: Text("No hay predicciones aún"))
          : ListView.builder(
        itemCount: vm.history.length,
        itemBuilder: (context, index) {
          final item = vm.history[index];

          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              leading: _buildConfidenceCircle(item),
              title: Text(
                item.resultado.contains("no-esophagus")
                    ? "Sin cáncer"
                    : "Con cáncer",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Confianza: ${item.confianza.toStringAsFixed(2)}%"),
                  Text("Fecha: ${item.fecha}"),
                  if (_extraMessage(item) != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _extraMessage(item)!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================
  //  WIDGET DEL CÍRCULO
  // ============================

  Widget _buildConfidenceCircle(item) {
    final Color color = _determineColor(item.resultado, item.confianza);
    final int confidenceInt = item.confianza.floor();

    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          "$confidenceInt%",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ============================
  //  LÓGICA DEL COLOR
  // ============================

  Color _determineColor(String resultado, double confianza) {
    final bool isNoCancer = resultado.contains("no-esophagus");
    final bool isCancer = resultado.contains("esophagus") && !isNoCancer;

    if (isNoCancer) {
      if (confianza > 90) return Colors.green;
      if (confianza > 75) return Colors.orange;
      return Colors.red;
    }

    if (isCancer) {
      if (confianza > 90) return Colors.red;
      if (confianza > 75) return Colors.orange;
      return Colors.green;
    }

    return Colors.grey; // fallback (solo si no coincide nada)
  }


  // ============================
  //  MENSAJE EXTRA
  // ============================

  String? _extraMessage(item) {
    final resultado = item.resultado;
    final confianza = item.confianza;

    if (resultado == "no-esophagus" && confianza > 90) {
      return "Todo parece estar bien";
    }

    if (resultado == "esophagus" && confianza > 90) {
      return "Debes ir con un doctor urgentemente";
    }

    return null;
  }
}
