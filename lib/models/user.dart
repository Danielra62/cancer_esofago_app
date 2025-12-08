class User {
  final int id;
  final String nombre;
  final String email;
  final String password;
  final int? pacienteId; // 🔹 opcional para vincular con encuestas

  User({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    this.pacienteId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      pacienteId: json['pacienteId'] is int
          ? json['pacienteId']
          : int.tryParse(json['pacienteId']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'password': password,
    if (pacienteId != null) 'pacienteId': pacienteId,
  };
}
