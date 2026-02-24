import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';

class NuevoGastoCombustibleScreen extends StatefulWidget {
  const NuevoGastoCombustibleScreen({Key? key}) : super(key: key);

  @override
  State<NuevoGastoCombustibleScreen> createState() => _NuevoGastoCombustibleScreenState();
}

class _NuevoGastoCombustibleScreenState extends State<NuevoGastoCombustibleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _kilometrajeController = TextEditingController();
  final _notasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gasto de Combustible')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: Validators.validateMonto,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kilometrajeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilometraje Actual',
                prefixIcon: Icon(Icons.speed),
              ),
              validator: Validators.validateKilometraje,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gasto guardado')),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _montoController.dispose();
    _kilometrajeController.dispose();
    _notasController.dispose();
    super.dispose();
  }
}
