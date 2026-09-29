import '../utils/constants.dart';

// Version allégée de User renvoyée par GET /users/top (classement public :
// pas d'email ni de rôle, donc User.fromJson planterait sur ces champs requis).
class TopUser {
  final String id;
  final String pseudo;
  final String? avatarUrl;
  final int sparksCount;

  TopUser({
    required this.id,
    required this.pseudo,
    this.avatarUrl,
    required this.sparksCount,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id:          json['id']          as String,
      pseudo:      json['pseudo']      as String,
      avatarUrl:   json['avatarUrl']   as String?,
      sparksCount: json['sparksCount'] as int,
    );
  }

  String? get displayAvatarUrl {
    if (avatarUrl == null) return null;
    return avatarUrl!.startsWith('http') ? avatarUrl : '$serverUrl$avatarUrl';
  }
}
