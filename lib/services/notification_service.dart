import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/detailsScreen.dart';
import 'api_service.dart';

class NotificationService {
  // Même nom de topic que NotificationService.FLARE_TOPIC côté back
  static const String flareTopic = 'flares';

  // Clé branchée sur le MaterialApp : permet de naviguer depuis un service,
  // qui n'a pas de BuildContext
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Évite d'abonner les listeners deux fois (ex : logout puis login)
  static bool _initialized = false;


  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final messaging = FirebaseMessaging.instance;

      // Android 13+ : affiche la popup système d'autorisation des notifications
      await messaging.requestPermission();
      await messaging.subscribeToTopic(flareTopic);

      // App en arrière-plan : l'utilisateur tape sur la notification
      FirebaseMessaging.onMessageOpenedApp.listen(_openPost);

      // App fermée : elle vient d'être lancée par un tap sur la notification
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) _openPost(initialMessage);
    } catch (e) {
      // Ex : simulateur iOS sans APNs — l'app doit rester utilisable sans notifications
      print('Notifications indisponibles : $e');
    }
  }

  Future<void> _openPost(RemoteMessage message) async {
    final postId = message.data['postId'];
    if (postId == null) return;

    try {
      final response = await ApiService.dio.get(
        '/posts/$postId',
      );
      final post = Post.fromJson(response.data);
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => DetailsScreen(post: post)),
      );
    } on DioException catch (e) {
      print('Erreur ouverture du Flare : ${e.message}');
    }
  }
}
