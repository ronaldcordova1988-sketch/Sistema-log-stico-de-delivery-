import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AuditoriaScreen extends StatelessWidget {
  const AuditoriaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auditoria '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar AuditoriaScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
