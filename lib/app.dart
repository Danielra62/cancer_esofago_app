import 'package:flutter/material.dart';

import 'screens/bienvenido.dart';
import 'screens/menu.dart';
import 'screens/login.dart';
import 'screens/registrar.dart';
import 'screens/editar_perfil.dart';
import 'screens/historial.dart';
import 'screens/resultados.dart';


//  Predicción
import 'screens/prediccion/prediccion_screen.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan.shade300),
        useMaterial3: true,
      ),
      initialRoute: '/bienvenido',
      routes: {
        '/bienvenido': (_) => const Bienvenido(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/history': (_) => const HistoryScreen(),
        '/results': (_) => const ResultsScreen(),
        '/prediccion': (_) => const PredictionScreen(),
      },
    );
  }
}
