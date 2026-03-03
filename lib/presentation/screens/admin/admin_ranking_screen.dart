import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_provider.dart';

class AdminRankingScreen extends ConsumerWidget {
  const AdminRankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresosAsync = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Productividad'),
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Lógica para agrupar y contar servicios por empleado
          final conteoServicios = <String, int>{};
          final montoGenerado = <String, double>{};

          for (var ingreso in ingresos) {
            conteoServicios[ingreso.empleadoId] = (conteoServicios[ingreso.empleadoId] ?? 0) + 1;
            montoGenerado[ingreso.empleadoId] = (montoGenerado[ingreso.empleadoId] ?? 0.0) + ingreso.monto;
          }

          // Ordenar empleados por cantidad de servicios (de mayor a menor)
          final rankingIds = conteoServicios.keys.toList()
            ..sort((a, b) => conteoServicios[b]!.compareTo(conteoServicios[a]!));

          if (rankingIds.isEmpty) {
            return const Center(child: Text('Aún no hay datos para generar el ranking.'));
          }

          return Column(
            children: [
              _buildPodium(rankingIds, conteoServicios),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rankingIds.length,
                  itemBuilder: (context, index) {
                    final id = rankingIds[index];
                    return _buildRankingTile(index + 1, id, conteoServicios[id]!, montoGenerado[id]!);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildPodium(List<String> ids, Map<String, int> conteo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.amber.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (ids.length > 1) _buildPodiumItem(ids[1], '2do', 80, Colors.grey, conteo[ids[1]]!),
          if (ids.length > 0) _buildPodiumItem(ids[0], '1ro', 110, Colors.amber, conteo[ids[0]]!),
          if (ids.length > 2) _buildPodiumItem(ids[2], '3ro', 60, Colors.brown.shade300, conteo[ids[2]]!),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(String id, String pos, double height, Color color, int total) {
    return Column(
      children: [
        Text(pos, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const Icon(Icons.person, size: 40),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Center(
            child: Text('$total', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        Text(id.substring(0, id.length > 5 ? 5 : id.length), style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildRankingTile(int rank, String id, int servicios, double monto) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: rank <= 3 ? Colors.amber : Colors.grey.shade200,
          child: Text('#$rank', style: TextStyle(color: rank <= 3 ? Colors.black : Colors.grey)),
        ),
        title: Text('Empleado: $id'),
        subtitle: Text('Total servicios: $servicios'),
        trailing: Text(
          '\$${monto.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    );
  }
}