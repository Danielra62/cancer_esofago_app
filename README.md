# cancer_esofago_app

Aplicación móvil desarrollada en Flutter para la detección de cáncer de esófago mediante inteligencia artificial. Permite a profesionales de la salud cargar imágenes endoscópicas y obtener una predicción automatizada con su nivel de confianza.

> **Backend:** Ver repositorio [cancer_esofago_app_backend](https://github.com/) — FastAPI + DenseNet121 desplegado en Azure App Service.

---

## Características

- Autenticación de usuarios (login y registro) con sesión persistente
- Selección de imagen endoscópica desde la galería del dispositivo
- Envío de imagen al modelo de IA en Azure para análisis
- Visualización del resultado: diagnóstico + porcentaje de confianza
- Historial de predicciones por usuario
- Edición de perfil
- URL del servidor configurable en tiempo de compilación sin hardcodeo

---

## Arquitectura

El proyecto sigue el patrón **MVVM** con `Provider` como gestor de estado.

```
lib/
├── config/
│   └── app_config.dart          # BASE_URL inyectada con --dart-define
├── models/
│   ├── user.dart
│   └── prediction_history.dart
├── screens/
│   ├── prediccion/
│   │   └── prediccion_screen.dart
│   ├── bienvenido.dart
│   ├── editar_perfil.dart
│   ├── historial.dart
│   ├── login.dart
│   ├── menu.dart
│   ├── registrar.dart
│   └── resultados.dart
├── services/
│   ├── auth_service.dart
│   └── prediction_service.dart
├── utils/
│   └── logger.dart
├── viewmodels/
│   ├── auth_viewmodel.dart
│   └── prediction_viewmodel.dart
├── app.dart
└── main.dart
```

---

## Requisitos

- Flutter SDK >= 3.9.2
- Android Studio o VS Code con extensión Flutter
- Dispositivo Android o emulador (API 21+)
- Backend desplegado y accesible (ver repositorio del backend)

---

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| provider | ^6.1.2 | Gestión de estado (MVVM) |
| http | ^1.2.2 | Peticiones HTTP al backend |
| shared_preferences | ^2.2.3 | Persistencia de sesión |
| image_picker | ^1.1.1 | Selección de imágenes |

---

## Instalación

```bash
git clone https://github.com/<tu-usuario>/cancer_esofago_app.git
cd cancer_esofago_app
flutter pub get
```

---

## Configuración de la URL del backend

La URL del servidor **no está hardcodeada**. Se inyecta en tiempo de compilación mediante `--dart-define`, lo que permite apuntar a diferentes entornos sin tocar el código.

El valor se lee en `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000', // emulador Android → localhost
  );
}
```

> En emuladores Android, `10.0.2.2` apunta al `localhost` de tu máquina. Para dispositivo físico en la misma red, usa la IP local de tu máquina (ej: `192.168.1.X`).

---

## Ejecución y compilación

**Correr en emulador:**
```bash
flutter run --dart-define=BASE_URL=http://10.0.2.2:8000
```

**Correr apuntando al servidor Azure:**
```bash
flutter run --dart-define=BASE_URL=https://<tu-servidor>.azurewebsites.net
```

**Compilar APK release:**
```bash
flutter build apk --release \
  --dart-define=BASE_URL=https://<tu-servidor>.azurewebsites.net
```

El APK generado queda en:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Flujo de la aplicación

1. El usuario abre la app y ve la pantalla de bienvenida
2. Se autentica (login) o crea una cuenta (registro)
3. Desde el menú accede a la pantalla de predicción
4. Selecciona una imagen endoscópica desde la galería
5. Presiona **Procesar Imagen**: la app sube la imagen al backend
6. El backend devuelve el diagnóstico y nivel de confianza
7. El resultado se guarda automáticamente en el historial
8. El usuario puede consultar predicciones anteriores en la sección de historial

---

## Endpoints del backend consumidos

| Método | Ruta | Descripción |
|---|---|---|
| POST | `/users/login` | Autenticación |
| POST | `/users` | Registro |
| POST | `/predict` | Envío de imagen para predicción |
| POST | `/predictions/save` | Guardar resultado en historial |
| GET | `/predicciones/{userId}` | Obtener historial del usuario |