import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistics_delivery_system/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('lightTheme should be created successfully', () {
      // Act
      final theme = AppTheme.lightTheme;
      // Assert
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppTheme.primaryYellow);
    });

    test('darkTheme should be created successfully', () {
      // Act
      final theme = AppTheme.darkTheme;
      // Assert
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, Colors.black);
      expect(theme.colorScheme.primary, AppTheme.primaryYellow);
    });
  });
}