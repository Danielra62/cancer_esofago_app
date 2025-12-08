import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  Widget _menuButton(BuildContext context, IconData icon, String title, String route) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.cyan.shade300, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        title: const Text('Menú Principal'),
        backgroundColor: Colors.cyan.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _menuButton(context, Icons.assessment, 'Ver resultados', '/results'),
            _menuButton(context, Icons.history, 'Historial', '/history'),
            _menuButton(context, Icons.edit, 'Editar información', '/profile'),
            _menuButton(context, Icons.bar_chart_rounded, 'Probabilidad de Cáncer', '/prediccion'),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
