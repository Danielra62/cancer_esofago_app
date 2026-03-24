class AppConfig {

  // La URL se inyecta en tiempo de compilación con:
  // flutter build apk --dart-define=BASE_URL=https://tu-servidor.azurewebsites.net


  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000', // emulador Android apunta a localhost de manera predeterminada
  );
}