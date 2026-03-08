import 'package:flutter_test/flutter_test.dart';
import 'package:logistics_delivery_system/data/models/ingreso_model.dart';
import 'package:logistics_delivery_system/domain/entities/servicio_entity.dart';

void main() {
  group('IngresoModel', () {
    final testDate = DateTime(2026, 3, 7);
    final tIngresoModel = IngresoModel(
      id: 'ingreso1',
      empleadoId: 'emp1',
      puntoA: 'Punto A',
      puntoB: 'Punto B',
      monto: 150.50,
      tipo: TipoServicio.carrera,
      fecha: testDate,
      liquidado: false,
    );

    final tIngresoJson = {
      'empleadoId': 'emp1',
      'puntoA': 'Punto A',
      'puntoB': 'Punto B',
      'monto': 150.50,
      'tipo': 'TipoServicio.carrera',
      'fecha': testDate.toIso8601String(),
      'liquidado': false,
    };

    test('should be a subclass of ServicioEntity', () {
      // Assert
      expect(tIngresoModel, isA<ServicioEntity>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Act
        final result = IngresoModel.fromJson(tIngresoJson, 'ingreso1');
        // Assert
        expect(result.id, tIngresoModel.id);
        expect(result.empleadoId, tIngresoModel.empleadoId);
        expect(result.puntoA, tIngresoModel.puntoA);
        expect(result.puntoB, tIngresoModel.puntoB);
        expect(result.monto, tIngresoModel.monto);
        expect(result.tipo, tIngresoModel.tipo);
        expect(result.fecha.toIso8601String(), tIngresoModel.fecha.toIso8601String());
        expect(result.liquidado, tIngresoModel.liquidado);
      });

      test('should handle missing optional fields with defaults', () {
        // Arrange
        final jsonWithMissingFields = {
          'empleadoId': 'emp1',
          'puntoA': 'Punto A',
          'puntoB': 'Punto B',
          'monto': 150.50,
        };
        // Act
        final result = IngresoModel.fromJson(jsonWithMissingFields, 'ingreso1');
        // Assert
        expect(result.tipo, TipoServicio.otro);
        expect(result.liquidado, false);
        expect(result.fecha, isA<DateTime>());
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // Act
        final result = tIngresoModel.toJson();
        // Assert
        expect(result, tIngresoJson);
      });
    });
  });
}