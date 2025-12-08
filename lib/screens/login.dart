import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
                        Icon(Icons.lock_open_rounded,
                            size: 80, color: Colors.cyan.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'Bienvenido de nuevo',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Ingrese un correo válido',
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (v) => v != null && v.isNotEmpty
                              ? null
                              : 'Ingrese su contraseña',
                        ),
                        const SizedBox(height: 24),

                        // Botón principal
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
                              final ok = await authVM.login(
                                _emailCtrl.text.trim(),
                                _passwordCtrl.text.trim(),
                              );
                              if (ok && mounted) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authVM.error ??
                                        'Error al iniciar sesión'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Iniciar sesión'),
                        ),

                        const SizedBox(height: 16),

                        // Enlace de registro
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/register'),
                          child: const Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
