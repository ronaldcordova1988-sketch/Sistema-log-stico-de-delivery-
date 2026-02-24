import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RealizarCorteScreen extends StatelessWidget {
  const RealizarCorteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Corte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 64, color: AppTheme.highlightColor),
            const SizedBox(height: 16),
            Text(
              'Admin: Realizar Corte',
              style: AppTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
