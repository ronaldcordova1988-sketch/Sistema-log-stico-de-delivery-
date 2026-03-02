import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RealizarCorteScreen extends StatelessWidget {
  const RealizarCorteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Corte '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar RealizarCorteScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
