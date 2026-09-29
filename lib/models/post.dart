import '../utils/constants.dart';

class Post {
  final String id;
  final String userId;
  final String titre;
  final String? imageUrl;
  final String? avatarUrl;
  final DateTime createdAt;
  final String pseudo;
  final String contenu;
  final String? source;
  final String categorie;
  final int sparksCount;
  final bool isSparked;
  final bool isElected; // post élu Flare au moins une fois

  Post({
    required this.id,
    required this.userId,
    required this.pseudo,
    required this.contenu,
    required this.categorie,
    required this.sparksCount,
    required this.titre,
    required this.createdAt,
    required this.isSparked,
    this.isElected = false,
    this.imageUrl,
    this.avatarUrl,
    this.source,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id:          json['id']          as String,
      userId:      json['userId']      as String,
      titre:       json['titre']       as String,
      pseudo:      json['pseudo']      as String,
      contenu:     json['contenu']     as String,
      categorie:   json['categorie']   as String,
      sparksCount: json['sparksCount'] as int,
      isSparked:   json['sparked']     as bool? ?? false,
      isElected:   json['elected']     as bool? ?? false,
      source:      json['source']      as String?,
      imageUrl:    json['imageUrl']    as String?,
      avatarUrl:    json['avatarUrl']  as String?,
      createdAt:   DateTime.parse('${json['createdAt']}Z').toLocal(),
    );
  }

  String? get displayImageUrl {
    if (imageUrl == null) return null;
    return imageUrl!.startsWith('http') ? imageUrl : '$serverUrl$imageUrl';
  }

  String? get displayAvatarUrl {
    if (avatarUrl == null) return null;
    return avatarUrl!.startsWith('http') ? avatarUrl : '$serverUrl$avatarUrl';
  }

  Post copyWith({bool? isSparked, int? sparksCount}) {
    return Post(
      id:          id,
      userId:      userId,
      titre:       titre,
      pseudo:      pseudo,
      contenu:     contenu,
      categorie:   categorie,
      createdAt:   createdAt,
      imageUrl:    imageUrl,
      avatarUrl:    avatarUrl,
      source:      source,
      sparksCount: sparksCount ?? this.sparksCount,
      isSparked:   isSparked  ?? this.isSparked,
      isElected:   isElected,
    );
  }
}
