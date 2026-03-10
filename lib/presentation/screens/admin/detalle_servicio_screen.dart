import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_logistico_delivery/domain/entities/servicio_entity.dart';
import 'package:sistema_logistico_delivery/presentation/providers/data_provider.dart';

class DetalleServicioScreen extends ConsumerWidget {
  final ServicioEntity servicio;

  const DetalleServicioScreen({super.key, required this.servicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Servicio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card de Información Principal
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('ID Transacción'),
                    Text(servicio.id, style: const TextStyle(fontFamily: 'Monospace')),
                    const Divider(),
                    _buildLabel('Fecha y Hora'),
                    Text(formatter.format(servicio.fecha), style: const TextStyle(fontSize: 16)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Tipo'),
                            Chip(
                              label: Text(servicio.tipo.toString().split('.').last.toUpperCase()),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildLabel('Monto'),
                            Text(
                              '\$${servicio.monto.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Card de Ruta
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ruta del Servicio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.circle, color: Colors.green, size: 16),
                      title: const Text('Origen'),
                      subtitle: Text(servicio.puntoA),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    Container(
  decoration: BoxDecoration(
    border: Border(left: BorderSide(color: Colors.grey, width: 1)),
  ),
  child: const SizedBox(height: 20), // O el hijo que tenga
),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red, size: 16),
                      title: const Text('Destino'),
                      subtitle: Text(servicio.puntoB),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card de Estado y Acciones
            Card(
              color: servicio.liquidado ? Colors.green.shade50 : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          servicio.liquidado ? Icons.check_circle : Icons.pending,
                          color: servicio.liquidado ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          servicio.liquidado ? 'ESTADO: LIQUIDADO' : 'ESTADO: PENDIENTE DE COBRO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: servicio.liquidado ? Colors.green.shade800 : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                    if (!servicio.liquidado) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () => _confirmarLiquidacion(context, ref),
                          child: const Text('LIQUIDAR AHORA'),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _confirmarLiquidacion(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Cobro'),
        content: Text('¿Deseas liquidar el servicio por \$${servicio.monto}? Se descontará de la deuda del empleado.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(dataProvider.notifier).liquidarIngreso(servicio.id);
      if (context.mounted) {
        Navigator.pop(context); // Regresar a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Servicio liquidado exitosamente')),
        );
      }
    }
  }
}