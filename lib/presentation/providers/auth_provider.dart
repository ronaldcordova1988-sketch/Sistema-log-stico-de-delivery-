import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Proveedor de Estado para la Autenticación de Firebase
/// 
/// Escucha los cambios en el estado de la sesión (Login/Logout)
/// y busca el rol del usuario en Firestore.
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  /// Inicializa la escucha del estado de autenticación
  void _init() {
    _auth.authStateChanges().listen((User? user) {
      state = AsyncValue.data(user);
    }, onError: (e, stack) {
      state = AsyncValue.error(e, stack);
    });
  }

  /// Cerrar Sesión con limpieza de seguridad
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _auth.signOut();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Obtener el Rol del Usuario (Admin o Empleado) desde Firestore
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['rol'] ?? 'empleado';
      }
      return 'empleado';
    } catch (e) {
      return 'empleado';
    }
  }
}

/// Provider global de Autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

/// Provider auxiliar para verificar si el usuario es Administrador
final isAdminProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.value;
  
  if (user == null) return false;
  
  final notifier = ref.read(authProvider.notifier);
  final rol = await notifier.getUserRole(user.uid);
  return rol == 'admin';
});