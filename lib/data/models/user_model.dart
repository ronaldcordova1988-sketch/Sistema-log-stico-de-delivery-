import 'package:sistema_logistico_delivery/domain/entities/usuario_entity.dart';

class UserModel extends UsuarioEntity {
  UserModel({
    required super.id,
    required super.nombre,
    required super.email,
    required super.rol,
    super.saldoPendiente,
    super.vehiculoId,
    required super.fechaRegistro,
  });

  // Getters para compatibilidad con nombres estándar de Firebase
  String get uid => id;
  String get displayName => nombre;

  // De Firebase a la App
  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? 'empleado',
      saldoPendiente: (json['saldoPendiente'] ?? 0.0).toDouble(),
      vehiculoId: json['vehiculoId'],
      fechaRegistro: json['fechaRegistro'] != null 
          ? DateTime.parse(json['fechaRegistro']) 
          : DateTime.now(),
    );
  }

  // De la App a Firebase
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'saldoPendiente': saldoPendiente,
      'vehiculoId': vehiculoId,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}