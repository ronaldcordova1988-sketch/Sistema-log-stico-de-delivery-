import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AlertasAnomaliasScreen extends StatelessWidget {
  const AlertasAnomaliasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas Anomalias '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar AlertasAnomaliasScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
