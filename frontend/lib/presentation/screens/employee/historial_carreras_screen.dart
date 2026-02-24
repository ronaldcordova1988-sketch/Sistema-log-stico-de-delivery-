import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HistorialCarrerasScreen extends StatelessWidget {
  const HistorialCarrerasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial Carreras'),
      ),
      body: Center(
        child: Text(
          'Pantalla: Historial Carreras',
          style: AppTheme.titleMedium,
        ),
      ),
    );
  }
}
