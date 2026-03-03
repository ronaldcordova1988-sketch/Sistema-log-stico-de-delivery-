import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/gasto_combustible_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';

class NuevoGastoCombustibleScreen extends ConsumerStatefulWidget {
  const NuevoGastoCombustibleScreen({super.key});

  @override
  ConsumerState<NuevoGastoCombustibleScreen> createState() => _NuevoGastoCombustibleScreenState();
}

class _NuevoGastoCombustibleScreenState extends ConsumerState<NuevoGastoCombustibleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _kmController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _montoController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final user = ref.read(authProvider).value;
    if (user == null) return;

    final nuevoGasto = GastoCombustibleModel.create(
      empleadoId: user.uid,
      monto: double.parse(_montoController.text),
      kilometraje: double.parse(_kmController.text),
    );

    try {
      // Llamada al provider para persistencia en Firebase/Hive
      await ref.read(dataProvider.notifier).addGastoCombustible(nuevoGasto);
      
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Gasto de combustible registrado')),
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
      app_appBar: AppBar(
        title: const Text('Cargar Combustible'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.local_gas_station, size: 80, color: Colors.orange),
              ),
              const SizedBox(height: 30),
              const Text(
                'Datos del Suministro',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Campo de Monto
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monto Pagado (\$)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el monto';
                  if (double.tryParse(v) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de Kilometraje
              TextFormField(
                controller: _kmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Kilometraje Actual (Odómetro)',
                  prefixIcon: const Icon(Icons.speed),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese el kilometraje';
                  if (double.tryParse(v) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón de Acción
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isSaving ? null : _guardarGasto,
                  child: _isSaving 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('REGISTRAR GASTO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}