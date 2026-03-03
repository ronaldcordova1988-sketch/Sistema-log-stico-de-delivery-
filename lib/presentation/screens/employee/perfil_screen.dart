import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    // Obtener iniciales para el avatar
    String getInitials(String? name) {
      if (name == null || name.isEmpty) return 'U';
      List<String> names = name.split(" ");
      if (names.length >= 2) {
        return "${names[0][0]}${names[1][0]}".toUpperCase();
      }
      return names[0][0].toUpperCase();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cabecera con Avatar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black26,
                    child: Text(
                      getInitials(user?.displayName),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.displayName ?? 'Usuario del Sistema',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    user?.email ?? 'correo@logistica.com',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Información Detallada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileTile(
                    Icons.badge_outlined, 
                    'ID de Empleado', 
                    user?.uid ?? 'No disponible'
                  ),
                  _buildProfileTile(
                    Icons.admin_panel_settings_outlined, 
                    'Rol de Acceso', 
                    'Empleado Operativo'
                  ),
                  _buildProfileTile(
                    Icons.security_outlined, 
                    'Estado de Cuenta', 
                    'Activa / Verificada'
                  ),
                  
                  const SizedBox(height: 40),

                  // Botón de Cerrar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).signOut(),
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('CERRAR SESIÓN', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Versión del Sistema: 2026.1.0 (64-bit)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber.shade700),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }
}
