# GudNuz — Contexte projet pour le développement Flutter

## Certification visée

**Titre Professionnel Concepteur Développeur d'Applications (CDA)** — Niveau 6 (Bac+3/4).
Le projet sera présenté à l'oral devant un jury. Le code, l'architecture et les choix techniques doivent être justifiables et démontrer la maîtrise des compétences du référentiel.

---

## Le projet

**GudNuz** est une application mobile **anti-doom scrolling** qui propose exclusivement du contenu positif dans 3 catégories : **Actus**, **Humour** et **Culture**. Pas de commentaires, pas de downvotes, pas d'algorithme de rétention. L'app intègre un mécanisme de **scroll éthique par opacité dégressive** pour limiter la consommation passive.

---

## Vocabulaire métier

| Terme usuel | Terme GudNuz | Description |
|---|---|---|
| Like | **Spark** (étincelle) | Un utilisateur donne un Spark à un post qu'il apprécie |
| Post élu | **Flare** (fusée éclairante) | Le post ayant reçu le plus de Sparks sur une fenêtre de 8h |
| Historique des Flares | **GudBox** | Page listant tous les anciens Flares |
| Newsletter | **GudLetter** | Email hebdomadaire envoyé le lundi matin |
| Niveaux utilisateur | Basés sur les Sparks reçus (enum) | Graine de sourire → Semeur de rires → Dealer de good vibes → Pusher de bonheur → Cartel du kiff → Parrain des bonnes ondes → Empereur du feel-good |

---

## Stack technique

| Couche | Technologie |
|---|---|
| Frontend | **Flutter** (iOS + Android) |
| Backend / API | **Java Spring Boot 3** |
| Base de données | **PostgreSQL 16** |
| Notifications push | **Firebase Cloud Messaging (FCM)** |
| Scheduler | **Spring Scheduler** (cron toutes les 8h) |
| Email | **JavaMailSender** + **Thymeleaf** templates |
| Déploiement | **Docker** sur VPS personnel |

---

## Architecture Flutter recommandée

```
lib/
├── main.dart
├── config/
│   └── app_routes.dart          # Navigation (GoRouter)
├── models/                      # Classes de données (Post, User, etc.)
├── services/
│   ├── api_service.dart         # Client HTTP (Dio) — appels API
│   ├── auth_service.dart        # Gestion JWT (stockage, refresh)
│   └── session_service.dart     # Logique scroll éthique (opacité + verrouillage)
├── screens/
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── feed_screen.dart
│   ├── create_post_screen.dart
│   ├── flare_screen.dart        # Post du moment + GudBox
│   ├── profile_screen.dart
│   ├── lockout_screen.dart      # Écran de pause (compte à rebours)
│   └── moderation_screen.dart   # Modo/Admin uniquement
├── widgets/                     # Composants réutilisables
│   ├── post_card.dart
│   ├── spark_button.dart
│   └── category_chip.dart
└── utils/
    └── constants.dart           # Couleurs, dimensions, URL de l'API
```

---

## Endpoints API — Référence pour le front

Base URL : `https://<domaine>/api`

### Auth (publiques)

| Méthode | Route | Description |
|---|---|---|
| POST | `/auth/register` | Inscription |
| POST | `/auth/login` | Connexion → retourne un JWT |

### Posts (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| GET | `/posts` | Feed — posts des 24 dernières heures. Filtrable par `?categorie=ACTU\|HUMOUR\|CULTURE` |
| GET | `/posts/{id}` | Détail d'un post |
| POST | `/posts` | Créer un post (multipart avec image optionnelle) |
| DELETE | `/posts/{id}` | Supprimer un post (auteur via JWT, ou MODO/ADMIN) |

### Sparks (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| POST | `/posts/{id}/sparks` | Donner un Spark (toggle — like/unlike) |

### Signalements (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| POST | `/posts/{id}/reports` | Signaler un post (motif obligatoire, unique par user/post) |

### Flare / GudBox (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| GET | `/flare/current` | Le Flare en cours |
| GET | `/flare/history` | La GudBox — historique des Flares |

### Profil (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| GET | `/me` | Mon profil (pseudo, email, rôle, niveau) |
| GET | `/me/posts` | Mes posts publiés |
| GET | `/users/{id}/posts` | Posts publics d'un autre utilisateur |

### Modération (MODERATOR / ADMIN)

| Méthode | Route | Description |
|---|---|---|
| GET | `/moderation/reports` | Tous les signalements |
| PATCH | `/moderation/posts/{postId}/remove` | Soft delete d'un post (statut → REMOVED) |

### GudLetter (USER authentifié)

| Méthode | Route | Description |
|---|---|---|
| POST | `/newsletter/subscribe` | S'abonner à la GudLetter |
| DELETE | `/newsletter/unsubscribe` | Se désabonner |

---

## Conventions REST établies

- **Pas de `user_id` dans les URL** — toujours dérivé du JWT côté back
- Routes `/me` pour les actions sur soi-même
- Noms de ressources au **pluriel** (`/posts`, `/reports`)
- **PATCH** pour les changements de statut (soft delete, modération)
- Filtrage par catégorie via **query param** : `?categorie=HUMOUR`

---

## Règles métier clés pour le front

- **Feed 24h** : les posts du feed sont filtrés par timestamp côté back (`created_at > now - 24h`), pas par un statut
- **Élection toutes les 8h** : un post peut être candidat sur jusqu'à 3 fenêtres d'élection
- **Source obligatoire** pour les posts de catégorie ACTU
- **Signalement** : un user ne peut signaler un même post qu'une seule fois (motif obligatoire)
- **Pas de downvote**, pas de commentaires
- **Pas d'historique de posts likés** sur le profil

---

## Scroll éthique — Implémentation Flutter

Mécanisme en deux temps, géré côté client uniquement :

1. **Opacité dégressive** : au fur et à mesure que l'utilisateur scrolle, l'opacité des posts diminue progressivement (via `ScrollController` + listener)
2. **Verrouillage** : une fois le seuil atteint, un écran de pause s'affiche avec un compte à rebours de 4h (stockage du timestamp via `shared_preferences`, décompte via `Timer.periodic`)

Toute la logique est encapsulée dans un `SessionService` dédié (séparation des responsabilités — valorisé par le jury CDA).

---

## Packages Flutter prévus

| Package | Usage |
|---|---|
| `dio` | Client HTTP pour appeler l'API |
| `go_router` | Navigation déclarative |
| `riverpod` ou `bloc` | Gestion d'état |
| `shared_preferences` | Stockage local (timestamp de verrouillage) |
| `firebase_messaging` | Réception des notifications push |
| `image_picker` | Upload d'image pour les posts |

---

## Écrans à développer

1. ✅ **Welcome Screen** — écran d'accueil avec logo et boutons Connexion/Inscription
2. **Login Screen** — formulaire email + mot de passe
3. **Register Screen** — formulaire inscription
4. **Feed Screen** — liste de posts paginée avec filtres par catégorie
5. **Create Post Screen** — formulaire de création (catégorie, texte, image optionnelle, source conditionnelle)
6. **Flare Screen** — le Flare du moment + GudBox
7. **Profile Screen** — pseudo, avatar, niveau, liste de mes posts
8. **Lockout Screen** — message bienveillant + compte à rebours 4h
9. **Moderation Screen** — liste des signalements + action de suppression (MODO/ADMIN)

---

## Consignes pour l'assistant

- L'élève apprend Flutter : **guider pas à pas**, expliquer le "pourquoi" de chaque widget et choix technique
- Ne pas donner de code complet sauf si explicitement demandé — préférer l'explication, la structure, puis laisser l'élève coder
- Toujours relier les choix techniques aux **compétences du référentiel CDA** quand c'est pertinent
- Documentation et communication en **français**
- L'élève challenge souvent les suggestions — expliquer le raisonnement, pas juste fournir des réponses
- Privilégier la **simplification** : pas de sur-ingénierie, le scope du projet est un CDA, pas une app en production
