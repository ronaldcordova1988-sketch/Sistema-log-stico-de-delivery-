import 'package:flutter_test/flutter_test.dart';
import 'package:logistics_delivery_system/data/models/user_model.dart';
import 'package:logistics_delivery_system/domain/entities/usuario_entity.dart';

void main() {
  group('UserModel', () {
    final testDate = DateTime(2026, 3, 7);
    final tUserModel = UserModel(
      id: '1',
      nombre: 'Test User',
      email: 'test@test.com',
      rol: 'empleado',
      saldoPendiente: 100.0,
      vehiculoId: 'v1',
      fechaRegistro: testDate,
    );

    final tUserJson = {
      'nombre': 'Test User',
      'email': 'test@test.com',
      'rol': 'empleado',
      'saldoPendiente': 100.0,
      'vehiculoId': 'v1',
      'fechaRegistro': testDate.toIso8601String(),
    };

    test('should be a subclass of UsuarioEntity', () {
      // Assert
      expect(tUserModel, isA<UsuarioEntity>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Act
        final result = UserModel.fromJson(tUserJson, '1');
        // Assert
        expect(result.id, tUserModel.id);
        expect(result.nombre, tUserModel.nombre);
        expect(result.email, tUserModel.email);
        expect(result.rol, tUserModel.rol);
        expect(result.saldoPendiente, tUserModel.saldoPendiente);
        expect(result.vehiculoId, tUserModel.vehiculoId);
        expect(result.fechaRegistro.toIso8601String(), tUserModel.fechaRegistro.toIso8601String());
      });

      test('should handle missing optional fields with defaults', () {
        // Arrange
        final jsonWithMissingFields = {
          'nombre': 'Test User',
          'email': 'test@test.com',
        };
        // Act
        final result = UserModel.fromJson(jsonWithMissingFields, '1');
        // Assert
        expect(result.rol, 'empleado');
        expect(result.saldoPendiente, 0.0);
        expect(result.vehiculoId, isNull);
        expect(result.fechaRegistro, isA<DateTime>());
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // Act
        final result = tUserModel.toJson();
        // Assert
        expect(result, tUserJson);
      });
    });
  });
}