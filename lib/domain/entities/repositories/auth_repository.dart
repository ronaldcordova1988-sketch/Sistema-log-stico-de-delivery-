import '../entities/usuario_entity.dart';

abstract class AuthRepository {
  Future<UsuarioEntity?> login(String email, String password);
  Future<UsuarioEntity?> register(UsuarioEntity usuario, String password);
  Future<void> logout();
  Future<UsuarioEntity?> getCurrentUser();
}