import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';

class AdminAlertasScreen extends ConsumerWidget {
  const AdminAlertasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresosAsync = ref.watch(dataProvider);
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas y Anomalías'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      body: ingresosAsync.when(
        data: (datos) {
          // AJUSTE: .timestamp -> .fecha
          final alertasGraves = datos.where((i) => 
            !i.liquidado && 
            DateTime.now().difference(i.fecha).inHours > 24
          ).toList();

          if (datos.isEmpty) {
            return const Center(child: Text('No hay actividad registrada.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildResumenAlertas(alertasGraves.length),
              const SizedBox(height: 20),
              const Text(
                'DETALLE DE INCIDENCIAS',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Divider(),
              
              ...alertasGraves.map((alerta) => _buildAlertaCard(
                context,
                title: 'Retraso en Liquidación',
                // AJUSTE: .timestamp -> .fecha
                subtitle: 'Empleado: ${alerta.empleadoId}\nDesde: ${formatter.format(alerta.fecha)}',
                monto: alerta.monto,
                isUrgent: true,
              )),

              _buildAlertaCard(
                context,
                title: 'Consumo Inusual de Combustible',
                subtitle: 'Vehículo ID: V-102\nExceso detectado: +15% vs promedio',
                monto: 45.00,
                isUrgent: false,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar auditoría: $e')),
      ),
    );
  }

  Widget _buildResumenAlertas(int cantidad) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cantidad > 0 ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cantidad > 0 ? Colors.red : Colors.green),
      ),
      child: Row(
        children: [
          Icon(
            cantidad > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: cantidad > 0 ? Colors.red : Colors.green,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cantidad > 0 ? 'ATENCIÓN REQUERIDA' : 'SISTEMA SEGURO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cantidad > 0 ? Colors.red : Colors.green,
                  ),
                ),
                Text(
                  cantidad > 0 
                    ? 'Se han detectado $cantidad anomalías críticas.' 
                    : 'No hay reportes de irregularidades hoy.',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertaCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double monto,
    required bool isUrgent,
  }) {
    return Card(
      elevation: isUrgent ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUrgent ? const BorderSide(color: Colors.red, width: 1) : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(
          isUrgent ? Icons.error_outline : Icons.info_outline,
          color: isUrgent ? Colors.red : Colors.orange,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          '\$${monto.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}