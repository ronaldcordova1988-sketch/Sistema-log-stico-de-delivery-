import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HorariosScreen extends StatelessWidget {
  const HorariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar HorariosScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
