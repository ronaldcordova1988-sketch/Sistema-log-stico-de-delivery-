import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RankingEmpleadosScreen extends StatelessWidget {
  const RankingEmpleadosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking Empleados '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar RankingEmpleadosScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
