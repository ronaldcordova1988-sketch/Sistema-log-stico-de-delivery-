import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/mantenimiento_aceite_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';

class NuevoMantenimientoScreen extends ConsumerStatefulWidget {
  const NuevoMantenimientoScreen({super.key});

  @override
  ConsumerState<NuevoMantenimientoScreen> createState() => _NuevoMantenimientoScreenState();
}

class _NuevoMantenimientoScreenState extends ConsumerState<NuevoMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _precioController = TextEditingController();
  final _kmActualController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _precioController.dispose();
    _kmActualController.dispose();
    super.dispose();
  }

  Future<void> _guardarMantenimiento() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final user = ref.read(authProvider).value;
    if (user == null) return;

    // Utilizamos el factory .create que ya tiene el +5000 km definido
    final nuevoMantenimiento = MantenimientoAceiteModel.create(
      empleadoId: user.uid,
      precio: double.parse(_precioController.text),
      kmActual: double.parse(_kmActualController.text),
    );

    try {
      // Llamada al provider para persistencia
      await ref.read(dataProvider.notifier).addMantenimientoAceite(nuevoMantenimiento);
      
      if (!mounted) return;
      
      // Mostrar resumen al usuario antes de salir
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('✅ Registro Exitoso'),
          content: Text('Próximo cambio programado a los:\n${nuevoMantenimiento.kmProximoCambio.toStringAsFixed(0)} KM'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra Dialog
                Navigator.pop(context); // Vuelve al Home
              },
              child: const Text('ENTENDIDO'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento de Aceite'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.build_circle_outlined, size: 80, color: Colors.blue),
              ),
              const SizedBox(height: 30),
              const Text(
                'Registro de Cambio de Aceite',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text('Se programará el aviso automáticamente (+5,000 km)'),
              const SizedBox(height: 25),

              // Campo de Precio
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Costo del Servicio (\$)',
                  prefixIcon: const Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el costo';
                  if (double.tryParse(v) == null) return 'Ingrese un monto válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de Kilometraje
              TextFormField(
                controller: _kmActualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Kilometraje en el Momento',
                  prefixIcon: const Icon(Icons.shutter_speed),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el kilometraje';
                  if (double.tryParse(v) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSaving ? null : _guardarMantenimiento,
                  child: _isSaving 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('GUARDAR Y PROGRAMAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}