class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String rol;
  final double saldoPendiente;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.saldoPendiente = 0.0,
  });

  // Getters para compatibilidad con código antiguo
  String get uid => id;
  String get displayName => nombre;

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      nombre: json['nombre'] ?? json['displayName'] ?? 'Usuario',
      email: json['email'] ?? '',
      rol: json['rol'] ?? 'user',
      saldoPendiente: (json['saldoPendiente'] ?? 0.0).toDouble(),
    );
  }
}