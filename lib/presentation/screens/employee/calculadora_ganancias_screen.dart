import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CalculadoraGananciasScreen extends StatelessWidget {
  const CalculadoraGananciasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Ganancias '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar CalculadoraGananciasScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
