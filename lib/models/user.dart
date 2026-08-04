class User {
  final String pseudo;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String id;
  final String role;
  final String userLevel;
  final DateTime createdAt;
  final int postsCount;
  final int sparksCount;
  final int flaresCount;

  User({
    required this.pseudo,
    required this.email,
    this.bio,
    this.avatarUrl,
    required this.id,
    required this.role,
    required this.userLevel,
    required this.createdAt,
    required this.postsCount,
    required this.sparksCount,
    required this.flaresCount,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:          json['id']          as String,
      pseudo:      json['pseudo']      as String,
      bio:         json['bio']         as String?,
      avatarUrl:   json['avatarUrl']   as String?,
      email:       json['email']       as String,
      role:        json['role']        as String,
      userLevel:   json['userLevel']   as String,
      postsCount:  json['postsCount']  as int,
      sparksCount: json['sparksCount'] as int,
      flaresCount: json['flaresCount'] as int,
      createdAt:   DateTime.parse(json['createdAt'] as String),
    );
  }


  String? get displayAvatarUrl {
    if (avatarUrl == null) return null;
    return avatarUrl!.startsWith('http') ? avatarUrl : 'http://localhost:8080$avatarUrl';
  }

}
