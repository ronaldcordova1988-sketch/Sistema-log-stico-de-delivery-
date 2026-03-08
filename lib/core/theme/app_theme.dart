import 'package:flutter/material.dart';

/// Clase Maestra de Estilos del Sistema Logístico
/// 
/// Define los colores corporativos:
/// - Amarillo Tráfico: Para acciones principales y alertas.
/// - Negro Carbón: Para fondos y elegancia en 64-bit.
/// - Blanco Nieve: Para lectura clara.
class AppTheme {
  // Paleta de Colores
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color secondaryDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);

  // --- TEMA CLARO ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryYellow,
        primary: primaryYellow,
        onPrimary: Colors.black,
        secondary: Colors.black,
        surface: Colors.white,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryYellow,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // --- TEMA OSCURO (Optimizado para Reparto Nocturno) ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryYellow,
        onPrimary: Colors.black,
        secondary: primaryYellow,
        surface: surfaceDark,
        background: Colors.black,
        error: errorRed,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: primaryYellow,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}