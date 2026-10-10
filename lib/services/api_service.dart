import 'package:dio/dio.dart';
import '../utils/constants.dart';
import 'auth_service.dart';
import 'notification_service.dart';

class ApiService {
  static final Dio dio = Dio(BaseOptions(baseUrl: apiBaseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        // ALLER : avant chaque requête
        onRequest: (options, handler) async {
          final token = await AuthService().getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options); // "c'est bon, envoie la requête"
        },

        // RETOUR EN ERREUR : quand le serveur répond une erreur
        onError: (error, handler) async {
          // 401 = token absent/expiré → on déconnecte et on renvoie vers la connexion
          if (error.response?.statusCode == 401) {
            await AuthService().logout();
            NotificationService.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil('/connexion', (route) => false);
          }
          // Dans tous les cas, l'erreur remonte jusqu'à l'écran qui a fait l'appel
          handler.next(error);
        },
      ),
    );
}
