import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../routes/app_router.dart';

/// Dashboard principal del Administrador
class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Ver notificaciones
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sin notificaciones nuevas')),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a configuración
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas principales
            _buildStatsGrid(context),

            const SizedBox(height: 24),

            // Botón de realizar corte
            _buildCorteButton(context),

            const SizedBox(height: 24),

            // Acciones rápidas
            _buildQuickActions(context),

            const SizedBox(height: 24),

            // Empleados activos
            _buildActiveEmployees(context),

            const SizedBox(height: 24),

            // Últimos cortes
            _buildRecentCortes(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    // TODO: Conectar con datos reales
    final stats = [
      {
        'label': 'Empleados Activos',
        'value': '15',
        'total': '/ ${AppConstants.maxSlots}',
        'icon': Icons.people,
        'color': AppTheme.successColor,
      },
      {
        'label': 'Total Ingresos',
        'value': '\$12,500',
        'total': 'este mes',
        'icon': Icons.trending_up,
        'color': AppTheme.highlightColor,
      },
      {
        'label': 'Total Gastos',
        'value': '\$4,200',
        'total': 'este mes',
        'icon': Icons.trending_down,
        'color': AppTheme.warningColor,
      },
      {
        'label': 'Balance Global',
        'value': '\$8,300',
        'total': 'neto',
        'icon': Icons.account_balance_wallet,
        'color': AppTheme.infoColor,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          label: stat['label'] as String,
          value: stat['value'] as String,
          total: stat['total'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String total,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Text(
                  total,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.realizarCorte),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.highlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.content_cut, size: 32),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REALIZAR CORTE',
                  style: AppTheme.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Liquidar registros del periodo',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.people_outline,
        'label': 'Gestión\nEmpleados',
        'route': AppRouter.gestionEmpleados,
        'color': AppTheme.successColor,
      },
      {
        'icon': Icons.analytics_outlined,
        'label': 'Analytics',
        'route': AppRouter.analytics,
        'color': AppTheme.infoColor,
      },
      {
        'icon': Icons.history,
        'label': 'Historial\nCortes',
        'route': AppRouter.historialCortes,
        'color': AppTheme.warningColor,
      },
      {
        'icon': Icons.emoji_events_outlined,
        'label': 'Ranking',
        'route': AppRouter.rankingEmpleados,
        'color': AppTheme.highlightColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acciones Rápidas', style: AppTheme.titleMedium),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return InkWell(
              onTap: () => Navigator.pushNamed(context, action['route'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (action['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActiveEmployees(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Empleados Activos', style: AppTheme.titleMedium),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.gestionEmpleados),
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // TODO: Conectar con datos reales
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              // TODO: Datos de ejemplo
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.highlightColor,
                  child: Text('E${index + 1}'),
                ),
                title: Text('Empleado ${index + 1}'),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 6),
                    Text('Slot ${index + 1}'),
                    const SizedBox(width: 16),
                    Text('Balance: \$${(500 + index * 100).toStringAsFixed(0)}'),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Ver detalles del empleado
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCortes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Últimos Cortes', style: AppTheme.titleMedium),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.historialCortes),
              child: const Text('Ver todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // TODO: Conectar con datos reales
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final date = DateTime.now().subtract(Duration(days: index * 7));
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.highlightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: AppTheme.highlightColor,
                  ),
                ),
                title: Text('Corte #${3 - index}'),
                subtitle: Text(
                  '${date.day}/${date.month}/${date.year} • 15 empleados',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      onPressed: () {
                        // TODO: Descargar PDF
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Descargando PDF...')),
                        );
                      },
                      tooltip: 'Descargar PDF',
                    ),
                    IconButton(
                      icon: const Icon(Icons.table_chart, color: Colors.green),
                      onPressed: () {
                        // TODO: Descargar Excel
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Descargando Excel...')),
                        );
                      },
                      tooltip: 'Descargar Excel',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
