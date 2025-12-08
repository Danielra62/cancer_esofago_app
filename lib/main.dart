import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/viewmodels/auth_viewmodel.dart';
import 'package:untitled/viewmodels/prediction_viewmodel.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthViewModel();
  await auth.loadSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: auth),
        ChangeNotifierProvider(create: (_) => PredictionViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

