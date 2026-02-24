import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MetasDiariasScreen extends StatelessWidget {
  const MetasDiariasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas Diarias'),
      ),
      body: Center(
        child: Text(
          'Pantalla: Metas Diarias',
          style: AppTheme.titleMedium,
        ),
      ),
    );
  }
}
