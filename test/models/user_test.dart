import 'package:flutter_test/flutter_test.dart';
import 'package:gudnuz/models/user.dart';
import 'package:gudnuz/utils/constants.dart';

void main() {
  group('User.fromJson', () {
    test('parse un JSON complet avec avatarUrl', () {
      final json = {
        'id': 'u1',
        'pseudo': 'Nathan',
        'email': 'nathan@example.com',
        'bio': 'Dealer de good vibes',
        'avatarUrl': '/uploads/avatar1.jpg',
        'role': 'USER',
        'userLevel': 'SEMEUR_DE_RIRES',
        'postsCount': 3,
        'sparksCount': 12,
        'flaresCount': 1,
        'createdAt': '2026-01-15T10:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, 'u1');
      expect(user.pseudo, 'Nathan');
      expect(user.bio, 'Dealer de good vibes');
      expect(user.avatarUrl, '/uploads/avatar1.jpg');
      expect(user.postsCount, 3);
      expect(user.createdAt, DateTime.parse('2026-01-15T10:00:00.000Z'));
    });

    test('parse un JSON sans bio ni avatarUrl (champs nullable)', () {
      final json = {
        'id': 'u2',
        'pseudo': 'Autre',
        'email': 'autre@example.com',
        'bio': null,
        'avatarUrl': null,
        'role': 'USER',
        'userLevel': 'GRAINE_DE_SOURIRE',
        'postsCount': 0,
        'sparksCount': 0,
        'flaresCount': 0,
        'createdAt': '2026-01-15T10:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.bio, isNull);
      expect(user.avatarUrl, isNull);
    });
  });

  group('User.displayAvatarUrl', () {
    User buildUser({String? avatarUrl}) {
      return User(
        id: 'u1',
        pseudo: 'Nathan',
        email: 'nathan@example.com',
        avatarUrl: avatarUrl,
        role: 'USER',
        userLevel: 'SEMEUR_DE_RIRES',
        createdAt: DateTime.now(),
        postsCount: 0,
        sparksCount: 0,
        flaresCount: 0,
      );
    }

    test('retourne null si avatarUrl est null', () {
      final user = buildUser(avatarUrl: null);
      expect(user.displayAvatarUrl, isNull);
    });

    test('préfixe une URL relative avec serverUrl', () {
      final user = buildUser(avatarUrl: '/uploads/avatar1.jpg');
      expect(user.displayAvatarUrl, '$serverUrl/uploads/avatar1.jpg');
    });

    test('ne modifie pas une URL déjà absolue', () {
      final user = buildUser(avatarUrl: 'https://cdn.example.com/avatar1.jpg');
      expect(user.displayAvatarUrl, 'https://cdn.example.com/avatar1.jpg');
    });
  });
}
