import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/models/ingreso_model.dart';

/// Pantalla para registrar una nueva carrera (SIN GPS)
class NuevaCarreraScreen extends StatefulWidget {
  const NuevaCarreraScreen({Key? key}) : super(key: key);

  @override
  State<NuevaCarreraScreen> createState() => _NuevaCarreraScreenState();
}

class _NuevaCarreraScreenState extends State<NuevaCarreraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _puntoAController = TextEditingController();
  final _puntoBController = TextEditingController();
  final _montoController = TextEditingController();
  TipoIngreso _tipoSeleccionado = TipoIngreso.carrera;
  bool _isLoading = false;

  @override
  void dispose() {
    _puntoAController.dispose();
    _puntoBController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _guardarCarrera() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Guardar en Firebase
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✓ Carrera guardada exitosamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Carrera'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tipo de ingreso
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de Ingreso', style: AppTheme.labelLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: TipoIngreso.values.map((tipo) {
                        return ChoiceChip(
                          label: Text(_getTipoTexto(tipo)),
                          selected: _tipoSeleccionado == tipo,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _tipoSeleccionado = tipo);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Punto A
            TextFormField(
              controller: _puntoAController,
              decoration: const InputDecoration(
                labelText: 'Punto A (Origen)',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: Validators.validateUbicacion,
            ),

            const SizedBox(height: 16),

            // Punto B
            TextFormField(
              controller: _puntoBController,
              decoration: const InputDecoration(
                labelText: 'Punto B (Destino)',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: Validators.validateUbicacion,
            ),

            const SizedBox(height: 16),

            // Monto
            TextFormField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixIcon: Icon(Icons.attach_money),
                prefixText: '\$',
              ),
              validator: Validators.validateMonto,
            ),

            const SizedBox(height: 32),

            // Botón guardar
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _guardarCarrera,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Guardando...' : 'Guardar Carrera'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTipoTexto(TipoIngreso tipo) {
    switch (tipo) {
      case TipoIngreso.carrera:
        return 'Carrera';
      case TipoIngreso.delivery:
        return 'Delivery';
      case TipoIngreso.transporte:
        return 'Transporte';
    }
  }
}
