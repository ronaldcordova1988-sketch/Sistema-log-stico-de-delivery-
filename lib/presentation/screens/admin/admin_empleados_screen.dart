import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_provider.dart';

class AdminEmpleadosScreen extends ConsumerWidget {
  const AdminEmpleadosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos la lista de ingresos para calcular saldos reales por empleado
    final ingresosAsync = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            onPressed: () {
              // Lógica para registrar un nuevo trabajador en el sistema
            },
          ),
        ],
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Lógica de 64 bits para agrupar saldos por cada empleado único
          final saldosPorEmpleado = <String, double>{};
          for (var ingreso in ingresos.where((i) => !i.liquidado)) {
            saldosPorEmpleado[ingreso.empleadoId] = 
                (saldosPorEmpleado[ingreso.empleadoId] ?? 0.0) + ingreso.monto;
          }

          if (saldosPorEmpleado.isEmpty && ingresos.isEmpty) {
            return const Center(
              child: Text('No hay empleados registrados en la base de datos.'),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blueGrey.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mostrando ${saldosPorEmpleado.length} empleados con saldos activos.',
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: saldosPorEmpleado.length,
                  itemBuilder: (context, index) {
                    final empleadoId = saldosPorEmpleado.keys.elementAt(index);
                    final saldo = saldosPorEmpleado[empleadoId];

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber.shade700,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          'Empleado: $empleadoId',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('Estado: Operativo / En Ruta'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('SALDO EN CALLE', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text(
                              '\$ ${saldo?.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: Colors.redAccent,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navegar al detalle individual del empleado
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar empleados: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Acción para ver reportes de nómina o pagos
        },
        label: const Text('Reporte de Nómina'),
        icon: const Icon(Icons.summarize_outlined),
        backgroundColor: Colors.black87,
      ),
    );
  }
}