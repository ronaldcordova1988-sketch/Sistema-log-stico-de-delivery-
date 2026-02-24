import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';

/// Estados de autenticación
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

/// Estado de autenticación
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Verificar si hay sesión activa
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(AppConstants.keyUserId);

      if (userId != null && userId.isNotEmpty) {
        // TODO: Cargar datos del usuario desde Firestore o Hive
        // Por ahora, crear un usuario de ejemplo
        final user = UserModel(
          uid: userId,
          nombre: 'Usuario Demo',
          pin: '1234',
          role: 'employee',
          isActive: true,
          slotNumber: 1,
          createdAt: DateTime.now(),
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error al verificar sesión',
      );
    }
  }

  /// Login con PIN
  Future<bool> login(String pin) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // TODO: Implementar validación real con Firebase
      // Por ahora, simulación:
      await Future.delayed(const Duration(seconds: 1));

      if (pin.length != 4) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'PIN debe tener 4 dígitos',
        );
        return false;
      }

      // Crear usuario según PIN
      final isAdmin = pin == '1234';
      final user = UserModel(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        nombre: isAdmin ? 'Administrador' : 'Empleado Demo',
        pin: pin,
        role: isAdmin ? AppConstants.adminRole : AppConstants.employeeRole,
        isActive: true,
        slotNumber: isAdmin ? 0 : 1,
        createdAt: DateTime.now(),
      );

      // Guardar sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserId, user.uid);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error al iniciar sesión: $e',
      );
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyUserId);

      state = AuthState.initial().copyWith(
        status: AuthStatus.unauthenticated,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al cerrar sesión: $e',
      );
    }
  }

  /// Actualizar información del usuario
  Future<void> updateUser(UserModel user) async {
    state = state.copyWith(user: user);
  }

  /// Verificar si el usuario es admin
  bool get isAdmin => state.user?.isAdmin ?? false;

  /// Verificar si el usuario es empleado
  bool get isEmployee => state.user?.isEmployee ?? false;

  /// Obtener usuario actual
  UserModel? get currentUser => state.user;
}

/// Provider global de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Provider para el estado de autenticación como Stream
final authStateProvider = StreamProvider<UserModel?>((ref) {
  // TODO: Implementar stream real desde Firebase Auth
  // Por ahora, devolver el usuario actual
  final authState = ref.watch(authProvider);
  return Stream.value(authState.user);
});

/// Provider para verificar si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

/// Provider para verificar si es admin
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.isAdmin ?? false;
});

/// Provider para el usuario actual
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});
