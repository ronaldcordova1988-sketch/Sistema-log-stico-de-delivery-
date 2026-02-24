class Validators {
  /// Validar PIN (4 dígitos numéricos)
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'El PIN es requerido';
    }
    if (value.length != 4) {
      return 'El PIN debe tener 4 dígitos';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'El PIN solo debe contener números';
    }
    return null;
  }

  /// Validar nombre
  static String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    if (value.length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }
    return null;
  }

  /// Validar monto (debe ser positivo)
  static String? validateMonto(String? value) {
    if (value == null || value.isEmpty) {
      return 'El monto es requerido';
    }
    
    final monto = double.tryParse(value);
    if (monto == null) {
      return 'Ingresa un monto válido';
    }
    if (monto <= 0) {
      return 'El monto debe ser mayor a 0';
    }
    if (monto > 10000) {
      return 'El monto no puede exceder \$10,000';
    }
    return null;
  }

  /// Validar kilometraje
  static String? validateKilometraje(String? value) {
    if (value == null || value.isEmpty) {
      return 'El kilometraje es requerido';
    }
    
    final km = double.tryParse(value);
    if (km == null) {
      return 'Ingresa un kilometraje válido';
    }
    if (km < 0) {
      return 'El kilometraje no puede ser negativo';
    }
    if (km > 999999) {
      return 'Kilometraje inválido';
    }
    return null;
  }

  /// Validar descripción
  static String? validateDescripcion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La descripción es requerida';
    }
    if (value.length < 3) {
      return 'La descripción debe tener al menos 3 caracteres';
    }
    if (value.length > 200) {
      return 'La descripción no puede exceder 200 caracteres';
    }
    return null;
  }

  /// Validar email (opcional, para futuras features)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email opcional
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  /// Validar teléfono (opcional, para futuras features)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Teléfono opcional
    }
    
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un teléfono válido (10 dígitos)';
    }
    return null;
  }

  /// Validar punto A/B (ubicación)
  static String? validateUbicacion(String? value) {
    if (value == null || value.isEmpty) {
      return 'La ubicación es requerida';
    }
    if (value.length < 3) {
      return 'La ubicación debe tener al menos 3 caracteres';
    }
    return null;
  }

  /// Validar slot number (1-30)
  static String? validateSlotNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El slot es requerido';
    }
    
    final slot = int.tryParse(value);
    if (slot == null) {
      return 'Ingresa un número de slot válido';
    }
    if (slot < 1 || slot > 30) {
      return 'El slot debe estar entre 1 y 30';
    }
    return null;
  }
}
