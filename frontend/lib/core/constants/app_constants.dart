class AppConstants {
  // ===== APP INFO =====
  static const String appName = 'Sistema Logístico Delivery';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Tu Empresa';
  
  // ===== FIREBASE COLLECTIONS =====
  static const String usersCollection = 'users';
  static const String ingresosCollection = 'ingresos';
  static const String gastosCombustibleCollection = 'gastos_combustible';
  static const String mantenimientoAceiteCollection = 'mantenimiento_aceite';
  static const String gastosVariosCollection = 'gastos_varios';
  static const String cortesCollection = 'cortes';
  static const String vehiculosCollection = 'vehiculos';
  static const String chatCollection = 'chat_messages';
  static const String anunciosCollection = 'anuncios';
  static const String horariosCollection = 'horarios';
  static const String metasCollection = 'metas';
  static const String auditLogCollection = 'audit_logs';
  static const String backupsCollection = 'backups';
  
  // ===== STORAGE PATHS =====
  static const String recibosCombustiblePath = 'recibos_combustible';
  static const String comprobantesVariosPath = 'comprobantes_varios';
  static const String profilePicturesPath = 'profile_pictures';
  static const String backupsPath = 'backups';
  static const String reportsPath = 'reports';
  
  // ===== HIVE BOXES =====
  static const String userBox = 'user_box';
  static const String ingresosBox = 'ingresos_box';
  static const String gastosBox = 'gastos_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  
  // ===== BUSINESS LOGIC =====
  static const int maxSlots = 30;
  static const int kmCambioAceite = 5000;
  static const int kmAlertaAceite = 200;
  static const int reminderMinutes = 10;
  static const int debounceMilliseconds = 500;
  static const int maxRetries = 3;
  static const int retryDelaySeconds = 2;
  static const int cacheExpirationHours = 24;
  
  // ===== ROLES =====
  static const String adminRole = 'admin';
  static const String employeeRole = 'employee';
  
  // ===== TIPOS DE INGRESO =====
  static const String tipoCarrera = 'carrera';
  static const String tipoDelivery = 'delivery';
  static const String tipoTransporte = 'transporte';
  
  // ===== LÍMITES =====
  static const int maxIngresosPorDia = 50;
  static const int maxGastosPorDia = 20;
  static const double maxMontoIngreso = 10000.0;
  static const double maxMontoGasto = 5000.0;
  
  // ===== CONFIGURACIÓN DE CORTES =====
  static const int diasAvisoCorte = 1;
  static const int horaCorteAutomatico = 2; // 2 AM
  
  // ===== ANALYTICS =====
  static const int diasGraficoBalance = 7;
  static const int diasComparativa = 30;
  static const int topEmpleados = 5;
  
  // ===== NOTIFICACIONES =====
  static const String notifChannelId = 'logistics_notifications';
  static const String notifChannelName = 'Notificaciones del Sistema';
  static const String notifChannelDesc = 'Notificaciones importantes del sistema logístico';
  
  // ===== URLS =====
  static const String backendUrl = 'https://tu-backend.onrender.com';
  static const String whatsappApiUrl = 'https://wa.me/';
  static const String supportEmail = 'soporte@tuempresa.com';
  static const String privacyPolicyUrl = 'https://tuempresa.com/privacy';
  static const String termsUrl = 'https://tuempresa.com/terms';
  
  // ===== SHARED PREFERENCES KEYS =====
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyFirstTime = 'first_time';
  static const String keyLastSync = 'last_sync';
  static const String keyUserId = 'user_id';
  static const String keyMetaDiaria = 'meta_diaria';
  static const String keyReminderEnabled = 'reminder_enabled';
  
  // ===== DURACIÓN DE ANIMACIONES =====
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // ===== FORMATOS =====
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  static const String currencySymbol = '\$';
  
  // ===== MENSAJES =====
  static const String msgSyncSuccess = '✓ Sincronización completada';
  static const String msgSyncError = '✗ Error en sincronización';
  static const String msgNoInternet = 'Sin conexión a internet';
  static const String msgOfflineMode = 'Modo offline activado';
  static const String msgDataSaved = 'Datos guardados localmente';
  
  // ===== RECORDATORIOS =====
  static const String reminderMessage = '🤖 ¡Hola! No olvides agregar tus carreras para mantener el balance al día';
  
  // ===== VALIDACIONES =====
  static const int minPinLength = 4;
  static const int maxPinLength = 4;
  static const int minNombreLength = 3;
  static const int maxNombreLength = 50;
  static const int maxDescripcionLength = 200;
}
