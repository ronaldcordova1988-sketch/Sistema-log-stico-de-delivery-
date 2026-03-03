import 'package:cloud_firestore/cloud_firestore.dart';

/// Roles disponibles en el sistema
enum UserRole { admin, empleado }

/// Modelo de Usuario Profesional para Gestión Logística
/// 
/// Diseñado para manejar la persistencia en Firestore y el estado local.
class UserModel {
  final String uid;
  final String nombre;
  final String email;
  final UserRole rol;
  final String? vehiculoId;
  final double saldoActual;
  final bool estaActivo;
  final DateTime? ultimaConexion;

  UserModel({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.rol,
    this.vehiculoId,
    this.saldoActual = 0.0,
    this.estaActivo = true,
    this.ultimaConexion,
  });

  /// Convierte un documento de Firestore a un objeto UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      uid: doc.id,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      rol: data['rol'] == 'admin' ? UserRole.admin : UserRole.empleado,
      vehiculoId: data['vehiculoId'],
      saldoActual: (data['saldoActual'] ?? 0.0).toDouble(),
      estaActivo: data['estaActivo'] ?? true,
      ultimaConexion: (data['ultimaConexion'] as Timestamp?)?.toDate(),
    );
  }

  /// Convierte un objeto UserModel a un Mapa para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol.toString().split('.').last, // Guarda 'admin' o 'empleado'
      'vehiculoId': vehiculoId,
      'saldoActual': saldoActual,
      'estaActivo': estaActivo,
      'ultimaConexion': FieldValue.serverTimestamp(),
    };
  }

  /// Método para crear una copia modificada (necesario para Riverpod)
  UserModel copyWith({
    String? nombre,
    UserRole? rol,
    String? vehiculoId,
    double? saldoActual,
    bool? estaActivo,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      saldoActual: saldoActual ?? this.saldoActual,
      estaActivo: estaActivo ?? this.estaActivo,
      ultimaConexion: ultimaConexion,
    );
  }
}