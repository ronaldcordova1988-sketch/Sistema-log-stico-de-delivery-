import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sistema_logistico_delivery/config/router/app_router.dart';
import 'package:sistema_logistico_delivery/presentation/providers/auth_provider.dart';

class HomeEmployeeScreen extends ConsumerWidget {
  const HomeEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user?.nombre ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              // Asumimos que el authProvider tiene un método signOut
              // ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refrescar datos del usuario
          return ref.refresh(authProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSaldoCard(
                context: context,
                saldo: user?.saldoPendiente ?? 0.0,
                formatter: currencyFormat,
                theme: theme,
              ),
              const SizedBox(height: 24),
              Text(
                'Operaciones',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard(
                    context: context,
                    icon: Icons.add_road_outlined,
                    label: 'Nueva Carrera',
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Implementar navegación a '/employee/nueva-carrera'
                    },
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.local_gas_station_outlined,
                    label: 'Registrar Gasto',
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Implementar navegación a '/employee/nuevo-gasto'
                    },
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.history_outlined,
                    label: 'Mi Historial',
                    color: Colors.purple,
                    onTap: () {
                      appRouter.go('/employee/historial');
                    },
                  ),
                  _buildActionCard(
                    context: context,
                    icon: Icons.calculate_outlined,
                    label: 'Calculadora',
                    color: Colors.green,
                    onTap: () {
                      appRouter.go('/employee/calculadora');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaldoCard({
    required BuildContext context,
    required double saldo,
    required NumberFormat formatter,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 4,
      color: theme.colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SALDO PENDIENTE DE LIQUIDAR',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(saldo),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: saldo > 0 ? theme.colorScheme.error : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Este es el monto acumulado que debes entregar al administrador.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}