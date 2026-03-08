import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';

class AdminAuditoriaScreen extends ConsumerWidget {
  const AdminAuditoriaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditoriaAsync = ref.watch(dataProvider);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoría del Sistema'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: auditoriaAsync.when(
        data: (eventos) {
          if (eventos.isEmpty) {
            return const Center(
              child: Text('No hay registros de auditoría disponibles.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: eventos.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final evento = eventos[index];
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionIndicator(evento.liquidado),
                    const SizedBox(width: 15),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                evento.liquidado ? 'ACCIÓN: LIQUIDACIÓN' : 'ACCIÓN: REGISTRO',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              // AJUSTE: .timestamp -> .fecha
                              Text(
                                dateFormat.format(evento.fecha),
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'El empleado ${evento.empleadoId} registró un movimiento de ${evento.puntoA} a ${evento.puntoB}.',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Monto afectado: \$${evento.monto.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.w600,
                              color: evento.liquidado ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar auditoría: $e')),
      ),
    );
  }

  Widget _buildActionIndicator(bool isSuccess) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSuccess ? Icons.account_balance_wallet : Icons.edit_note,
        size: 20,
        color: isSuccess ? Colors.green : Colors.blue,
      ),
    );
  }
}