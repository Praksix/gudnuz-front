// URL du serveur, choisie à la compilation.
// Par défaut : l'API de prod sur le VPS.
// Pour le back local : flutter run --dart-define=API_URL=http://localhost:8080
const String serverUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://vps-096390e2.vps.ovh.net',
);

// Base des appels Dio (toutes les routes sont sous /api)
const String apiBaseUrl = '$serverUrl/api';
