import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController paisController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    ciudadController.dispose();
    paisController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        title: const Text('Editar perfil'),
        backgroundColor: Colors.cyan.shade300,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: _inputDecoration('Nombre completo'),
                      validator: (v) => v == null || v.isEmpty ? 'Ingrese su nombre' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: edadController,
                      decoration: _inputDecoration('Edad'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingrese su edad';
                        final n = int.tryParse(v);
                        if (n == null || n <= 0) return 'Ingrese un número válido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: ciudadController,
                      decoration: _inputDecoration('Ciudad'),
                      validator: (v) => v == null || v.isEmpty ? 'Ingrese su ciudad' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: paisController,
                      decoration: _inputDecoration('País'),
                      validator: (v) => v == null || v.isEmpty ? 'Ingrese su país' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.cyan.shade300,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final perfil = {
                              'nombre': nombreController.text,
                              'edad': edadController.text,
                              'ciudad': ciudadController.text,
                              'pais': paisController.text,
                            };

                            Navigator.pop(context, perfil);
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
