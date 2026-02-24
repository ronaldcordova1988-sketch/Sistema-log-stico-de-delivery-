import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Usuario (Admin/Empleado)
class UserModel {
  final String uid;
  final String nombre;
  final String pin;
  final String role; // 'admin' o 'employee'
  final bool isActive;
  final int slotNumber; // 1-30
  final DateTime createdAt;
  final DateTime? lastSync;
  final String? vehiculoId;
  final String? profilePictureUrl;
  final double? metaDiaria;

  UserModel({
    required this.uid,
    required this.nombre,
    required this.pin,
    required this.role,
    required this.isActive,
    required this.slotNumber,
    required this.createdAt,
    this.lastSync,
    this.vehiculoId,
    this.profilePictureUrl,
    this.metaDiaria,
  });

  // Crear desde Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      nombre: data['nombre'] ?? '',
      pin: data['pin'] ?? '',
      role: data['role'] ?? 'employee',
      isActive: data['isActive'] ?? false,
      slotNumber: data['slotNumber'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastSync: data['lastSync'] != null 
          ? (data['lastSync'] as Timestamp).toDate() 
          : null,
      vehiculoId: data['vehiculoId'],
      profilePictureUrl: data['profilePictureUrl'],
      metaDiaria: data['metaDiaria']?.toDouble(),
    );
  }

  // Convertir a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'pin': pin,
      'role': role,
      'isActive': isActive,
      'slotNumber': slotNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSync': lastSync != null ? Timestamp.fromDate(lastSync!) : null,
      'vehiculoId': vehiculoId,
      'profilePictureUrl': profilePictureUrl,
      'metaDiaria': metaDiaria,
    };
  }

  // Convertir a Hive
  Map<String, dynamic> toHive() {
    return {
      'uid': uid,
      'nombre': nombre,
      'pin': pin,
      'role': role,
      'isActive': isActive,
      'slotNumber': slotNumber,
      'createdAt': createdAt.toIso8601String(),
      'lastSync': lastSync?.toIso8601String(),
      'vehiculoId': vehiculoId,
      'profilePictureUrl': profilePictureUrl,
      'metaDiaria': metaDiaria,
    };
  }

  // Crear desde Hive
  factory UserModel.fromHive(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      nombre: data['nombre'],
      pin: data['pin'],
      role: data['role'],
      isActive: data['isActive'],
      slotNumber: data['slotNumber'],
      createdAt: DateTime.parse(data['createdAt']),
      lastSync: data['lastSync'] != null 
          ? DateTime.parse(data['lastSync']) 
          : null,
      vehiculoId: data['vehiculoId'],
      profilePictureUrl: data['profilePictureUrl'],
      metaDiaria: data['metaDiaria']?.toDouble(),
    );
  }

  // CopyWith
  UserModel copyWith({
    String? uid,
    String? nombre,
    String? pin,
    String? role,
    bool? isActive,
    int? slotNumber,
    DateTime? createdAt,
    DateTime? lastSync,
    String? vehiculoId,
    String? profilePictureUrl,
    double? metaDiaria,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      nombre: nombre ?? this.nombre,
      pin: pin ?? this.pin,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      slotNumber: slotNumber ?? this.slotNumber,
      createdAt: createdAt ?? this.createdAt,
      lastSync: lastSync ?? this.lastSync,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      metaDiaria: metaDiaria ?? this.metaDiaria,
    );
  }

  // Getters útiles
  bool get isAdmin => role == 'admin';
  bool get isEmployee => role == 'employee';
  bool get tieneMeta => metaDiaria != null && metaDiaria! > 0;
  bool get tieneVehiculo => vehiculoId != null;
}
