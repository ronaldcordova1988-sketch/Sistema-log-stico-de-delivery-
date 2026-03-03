import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importaciones de pantallas (Asegúrate de que los paths coincidan con tu estructura)
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/employee/home_employee_screen.dart';
import '../../presentation/screens/employee/perfil_screen.dart';
import '../../presentation/screens/employee/calculadora_ganancias_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/admin/admin_cortes_screen.dart';
import '../../presentation/screens/admin/admin_empleados_screen.dart';
import '../../presentation/screens/admin/admin_flota_screen.dart';
import '../../presentation/screens/admin/admin_ranking_screen.dart';
import '../../presentation/screens/admin/admin_alertas_screen.dart';
import '../../presentation/screens/admin/admin_analytics_screen.dart';
import '../../presentation/screens/admin/admin_auditoria_screen.dart';
import '../../presentation/screens/admin/admin_historial_cortes_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // --- AUTENTICACIÓN ---
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // --- MÓDULO EMPLEADO ---
    GoRoute(
      path: '/employee/home',
      builder: (context, state) => const HomeEmployeeScreen(),
    ),
    GoRoute(
      path: '/employee/perfil',
      builder: (context, state) => const PerfilScreen(),
    ),
    GoRoute(
      path: '/employee/calculadora',
      builder: (context, state) => const CalculadoraGananciasScreen(),
    ),

    // --- MÓDULO ADMINISTRADOR ---
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/cortes',
      builder: (context, state) => const AdminCortesScreen(),
    ),
    GoRoute(
      path: '/admin/empleados',
      builder: (context, state) => const AdminEmpleadosScreen(),
    ),
    GoRoute(
      path: '/admin/flota',
      builder: (context, state) => const AdminFlotaScreen(),
    ),
    GoRoute(
      path: '/admin/ranking',
      builder: (context, state) => const AdminRankingScreen(),
    ),
    GoRoute(
      path: '/admin/alertas',
      builder: (context, state) => const AdminAlertasScreen(),
    ),
    GoRoute(
      path: '/admin/analytics',
      builder: (context, state) => const AdminAnalyticsScreen(),
    ),
    GoRoute(
      path: '/admin/auditoria',
      builder: (context, state) => const AdminAuditoriaScreen(),
    ),
    GoRoute(
      path: '/admin/historial-cortes',
      builder: (context, state) => const AdminHistorialCortesScreen(),
    ),
  ],
);