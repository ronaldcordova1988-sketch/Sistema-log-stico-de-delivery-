import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HistorialCortesScreen extends StatelessWidget {
  const HistorialCortesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial Cortes '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar HistorialCortesScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
