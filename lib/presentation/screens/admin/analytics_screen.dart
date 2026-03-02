import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar AnalyticsScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
