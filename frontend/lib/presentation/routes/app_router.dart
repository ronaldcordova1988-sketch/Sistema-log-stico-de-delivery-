import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/employee/home_employee_screen.dart';
import '../screens/employee/nueva_carrera_screen.dart';
import '../screens/employee/nuevo_gasto_combustible_screen.dart';
import '../screens/employee/nuevo_mantenimiento_screen.dart';
import '../screens/employee/nuevo_gasto_varios_screen.dart';
import '../screens/employee/historial_carreras_screen.dart';
import '../screens/employee/calculadora_ganancias_screen.dart';
import '../screens/employee/metas_diarias_screen.dart';
import '../screens/employee/perfil_screen.dart';
import '../screens/employee/horarios_screen.dart';
import '../screens/admin/dashboard_admin_screen.dart';
import '../screens/admin/realizar_corte_screen.dart';
import '../screens/admin/historial_cortes_screen.dart';
import '../screens/admin/gestion_empleados_screen.dart';
import '../screens/admin/analytics_screen.dart';
import '../screens/admin/ranking_empleados_screen.dart';

/// Sistema de navegación de la aplicación
class AppRouter {
  // ===== RUTAS AUTH =====
  static const String splash = '/';
  static const String login = '/login';
  
  // ===== RUTAS EMPLEADO =====
  static const String employeeHome = '/employee/home';
  static const String nuevaCarrera = '/employee/nueva-carrera';
  static const String nuevoGastoCombustible = '/employee/nuevo-gasto-combustible';
  static const String nuevoMantenimiento = '/employee/nuevo-mantenimiento';
  static const String nuevoGastoVarios = '/employee/nuevo-gasto-varios';
  static const String historialCarreras = '/employee/historial-carreras';
  static const String calculadoraGanancias = '/employee/calculadora-ganancias';
  static const String metasDiarias = '/employee/metas-diarias';
  static const String perfil = '/employee/perfil';
  static const String horarios = '/employee/horarios';
  
  // ===== RUTAS ADMIN =====
  static const String adminDashboard = '/admin/dashboard';
  static const String realizarCorte = '/admin/realizar-corte';
  static const String historialCortes = '/admin/historial-cortes';
  static const String gestionEmpleados = '/admin/gestion-empleados';
  static const String analytics = '/admin/analytics';
  static const String rankingEmpleados = '/admin/ranking-empleados';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // AUTH
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      // EMPLEADO
      case employeeHome:
        return MaterialPageRoute(builder: (_) => const HomeEmployeeScreen());
      
      case nuevaCarrera:
        return MaterialPageRoute(builder: (_) => const NuevaCarreraScreen());
      
      case nuevoGastoCombustible:
        return MaterialPageRoute(builder: (_) => const NuevoGastoCombustibleScreen());
      
      case nuevoMantenimiento:
        return MaterialPageRoute(builder: (_) => const NuevoMantenimientoScreen());
      
      case nuevoGastoVarios:
        return MaterialPageRoute(builder: (_) => const NuevoGastoVariosScreen());
      
      case historialCarreras:
        return MaterialPageRoute(builder: (_) => const HistorialCarrerasScreen());
      
      case calculadoraGanancias:
        return MaterialPageRoute(builder: (_) => const CalculadoraGananciasScreen());
      
      case metasDiarias:
        return MaterialPageRoute(builder: (_) => const MetasDiariasScreen());
      
      case perfil:
        return MaterialPageRoute(builder: (_) => const PerfilScreen());
      
      case horarios:
        return MaterialPageRoute(builder: (_) => const HorariosScreen());
      
      // ADMIN
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const DashboardAdminScreen());
      
      case realizarCorte:
        return MaterialPageRoute(builder: (_) => const RealizarCorteScreen());
      
      case historialCortes:
        return MaterialPageRoute(builder: (_) => const HistorialCortesScreen());
      
      case gestionEmpleados:
        return MaterialPageRoute(builder: (_) => const GestionEmpleadosScreen());
      
      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      
      case rankingEmpleados:
        return MaterialPageRoute(builder: (_) => const RankingEmpleadosScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Ruta no encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
