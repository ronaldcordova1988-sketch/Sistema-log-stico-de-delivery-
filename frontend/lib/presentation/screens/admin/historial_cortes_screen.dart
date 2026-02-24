import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HistorialCortesScreen extends StatelessWidget {
  const HistorialCortesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial Cortes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 64, color: AppTheme.highlightColor),
            const SizedBox(height: 16),
            Text(
              'Admin: Historial Cortes',
              style: AppTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
