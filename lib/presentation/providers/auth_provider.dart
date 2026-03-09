import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_logistico_delivery/data/datasources/remote_datasource.dart';
import 'package:sistema_logistico_delivery/data/models/user_model.dart';
import 'package:sistema_logistico_delivery/data/repositories/logistica_repository_impl.dart';
import 'package:sistema_logistico_delivery/domain/repositories/logistica_repository.dart';

// DEPENDENCIAS DE DATOS (Movidas aquí para romper dependencias circulares)
final remoteDataSourceProvider = Provider((ref) => RemoteDataSource());

final logisticaRepositoryProvider = Provider<LogisticaRepository>((ref) {
  final dataSource = ref.watch(remoteDataSourceProvider);
  return LogisticaRepositoryImpl(dataSource);
});

/// Proveedor de Estado para la Autenticación de Firebase
/// 
/// Escucha los cambios en el estado de la sesión (Login/Logout)
/// y busca el perfil completo del usuario (UserModel) en Firestore.
class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  /// Inicializa la escucha del estado de autenticación
  void _init() {
    _auth.authStateChanges().listen((fb_auth.User? firebaseUser) async {
      if (firebaseUser == null) {
        state = const AsyncValue.data(null);
        return;
      }
      try {
        // Al detectar un usuario de Firebase, buscamos nuestro modelo de datos personalizado
        final userModel = await _ref.read(remoteDataSourceProvider).getUsuario(firebaseUser.uid);
        state = AsyncValue.data(userModel);
      } catch (e, stack) {
        state = AsyncValue.error(e, stack);
      }
    }, onError: (e, stack) {
      state = AsyncValue.error(e, stack);
    });
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // El listener de authStateChanges se encargará de actualizar el estado a null.
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider global de Autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});

/// Provider auxiliar para verificar si el usuario es Administrador
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.maybeWhen(
    data: (user) => user?.rol == 'admin',
    orElse: () => false,
  );
});