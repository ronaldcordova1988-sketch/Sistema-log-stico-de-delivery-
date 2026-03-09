import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_logistico_delivery/domain/entities/servicio_entity.dart';
import 'package:sistema_logistico_delivery/presentation/providers/data_provider.dart';
import 'package:sistema_logistico_delivery/presentation/screens/admin/detalle_servicio_screen.dart';

class HistorialCarrerasScreen extends ConsumerStatefulWidget {
  const HistorialCarrerasScreen({super.key});

  @override
  ConsumerState<HistorialCarrerasScreen> createState() => _HistorialCarrerasScreenState();
}

class _HistorialCarrerasScreenState extends ConsumerState<HistorialCarrerasScreen> {
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_fechaInicio ?? initialDate) : (_fechaFin ?? initialDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: isStartDate ? 'SELECCIONAR FECHA INICIAL' : 'SELECCIONAR FECHA FINAL',
    );

    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _fechaInicio = newDate;
        } else {
          // Ajustar la fecha final para que incluya todo el día
          _fechaFin = DateTime(newDate.year, newDate.month, newDate.day, 23, 59, 59);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final historialAsync = ref.watch(historialEmpleadoProvider);
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Historial de Servicios'),
      ),
      body: Column(
        children: [
          _buildFiltroFechas(context, formatter),
          Expanded(
            child: historialAsync.when(
              data: (servicios) {
                final serviciosFiltrados = servicios.where((s) {
                  final despuesDeInicio = _fechaInicio == null || s.fecha.isAfter(_fechaInicio!);
                  final antesDeFin = _fechaFin == null || s.fecha.isBefore(_fechaFin!);
                  return despuesDeInicio && antesDeFin;
                }).toList();

                if (serviciosFiltrados.isEmpty) {
                  return const Center(
                    child: Text('No hay servicios en el rango de fechas seleccionado.'),
                  );
                }

                return ListView.builder(
                  itemCount: serviciosFiltrados.length,
                  itemBuilder: (context, index) {
                    final servicio = serviciosFiltrados[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: servicio.liquidado ? Colors.green.shade100 : Colors.orange.shade100,
                          child: Icon(
                            servicio.liquidado ? Icons.check_circle_outline : Icons.pending_outlined,
                            color: servicio.liquidado ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text('De: ${servicio.puntoA} a ${servicio.puntoB}'),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(servicio.fecha)),
                        trailing: Text(
                          '\$${servicio.monto.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: servicio.liquidado ? Colors.green : Colors.orange.shade800,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetalleServicioScreen(servicio: servicio)),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error al cargar historial: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroFechas(BuildContext context, DateFormat formatter) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _selectDate(context, true),
              icon: const Icon(Icons.calendar_today_outlined, size: 16),
              label: Text(_fechaInicio == null ? 'Desde' : formatter.format(_fechaInicio!)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _selectDate(context, false),
              icon: const Icon(Icons.event, size: 16),
              label: Text(_fechaFin == null ? 'Hasta' : formatter.format(_fechaFin!)),
            ),
          ),
          if (_fechaInicio != null || _fechaFin != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.redAccent),
              tooltip: 'Limpiar filtros',
              onPressed: () => setState(() {
                _fechaInicio = null;
                _fechaFin = null;
              }),
            )
        ],
      ),
    );
  }
}