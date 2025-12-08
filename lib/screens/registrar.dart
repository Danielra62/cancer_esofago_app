import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan.shade300, Colors.cyan.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.person_add_alt_1, size: 80, color: Colors.cyan.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'Crea tu cuenta',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nombreCtrl,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese su nombre' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Ingrese un correo válido',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (v) => v != null && v.length >= 6
                              ? null
                              : 'Debe tener al menos 6 caracteres',
                        ),
                        const SizedBox(height: 24),
                        authVM.loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool ok = await authVM.register(
                                _nombreCtrl.text.trim(),
                                _emailCtrl.text.trim(),
                                _passwordCtrl.text.trim(),
                              );
                              if (ok && mounted) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authVM.error ??
                                        "Error al registrar usuario"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Registrarme'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
