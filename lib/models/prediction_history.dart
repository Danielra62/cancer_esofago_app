class PredictionHistory {
  final int id;
  final String resultado;
  final double confianza;
  final DateTime fecha;

  PredictionHistory({
    required this.id,
    required this.resultado,
    required this.confianza,
    required this.fecha,
  });

  factory PredictionHistory.fromJson(Map<String, dynamic> json) {
    return PredictionHistory(
      id: json['id'],
      resultado: json['resultado'],
      confianza: (json['confianza'] as num).toDouble(),
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
