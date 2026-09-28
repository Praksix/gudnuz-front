import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../widgets/flare_card.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'dart:ui';
import 'lockoutScreen.dart';
import 'moderationScreen.dart';
import 'topUsersScreen.dart';
import 'gudBoxScreen.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}


class _FeedScreenState extends State<FeedScreen> {

  final ScrollController  _scrollController = ScrollController();
  double _opacity = 1.0;
  bool _isLocked = false;





  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  // Le client HTTP — à déclarer une seule fois dans la classe
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api', // émulateur Android
  ));

  late Future<List<Post>> _postsFuture;
  List<Post> _posts = [];

  late Future<User> _userFuture;

  // Flare actuel — null s'il n'y en a pas encore (dans ce cas on n'affiche rien)
  Post? _flare;



  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
    _userFuture = _loadUser();
    _loadFlare();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final seuilDeDepart = 1200;
      final seuilDeFin = 1700;
      final t = ((offset - seuilDeDepart) / (seuilDeFin - seuilDeDepart)).clamp(0.0, 1.0);
      final opacity = lerpDouble(1.0, 0.0, t)!;
      setState(() => _opacity = opacity);
      print(_opacity);
      if (_opacity <= 0.2 && !_isLocked) {
      _isLocked = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LockoutScreen()),
      );

      }
    });


  }

  Future<List<Post>> _loadPosts({String? categorie}) async {
    final posts = await getPosts(categorie: categorie);
    setState(() => _posts = posts);
    return posts;
  }

  Future<User> _loadUser() async {
    final user = await getUser();
    return user;
  }

  Future<void> _loadFlare() async {
    final flare = await getCurrentFlare();
    if (!mounted) return;
    setState(() => _flare = flare);
  }

  Future<void> _onRefresh() async {
    final cat = _categorie == "TOP" ? null : _categorie;
    final posts = await getPosts(categorie: cat);
    setState(() => _posts = posts);
    await _loadFlare();
  }

  void _onSparkToggled(Post updatedPost) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) _posts[index] = updatedPost;
      // Le Flare apparaît aussi dans la liste : on garde les deux cartes synchronisées
      if (_flare?.id == updatedPost.id) _flare = updatedPost;
    });
  }



  String _categorie = "TOP";

  Future<List<Post>> getPosts({String? categorie}) async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        '/posts',
        queryParameters: categorie != null ? {'categorie': categorie} : null,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // response.data est une List de Maps
      final List<dynamic> data = response.data;
      print('POSTS REÇUS : $data');
      return data.map((json) {
        print('PARSING : $json');
        return Post.fromJson(json);
      }).toList();

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }

  Future<Post?> getCurrentFlare() async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        '/flare/current',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Pas de Flare élu → le back renvoie un 200 avec un corps vide (pas une Map)
      if (response.data is! Map<String, dynamic>) return null;
      return Post.fromJson(response.data);

    } on DioException catch (e) {
      // Le Flare est un bonus : en cas d'erreur, on affiche juste le feed normal
      print('Erreur Flare : ${e.message}');
      return null;
    }
  }

  Future<User> getUser() async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return User.fromJson(response.data);

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2EDE1),
      appBar: AppBar(
        title: Text(_categorie, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          FutureBuilder<User>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final user = snapshot.data!;
              if (user.role != 'ADMIN' && user.role != 'MODERATOR') return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.shield_outlined),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ModerationScreen())),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFFF2EDE1),
        child: Column(
          children: [
            DrawerHeader(
              child: Text("GudNuz", style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text("Top", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  _categorie = "TOP";
                  _postsFuture = _loadPosts();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Actualités", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  _categorie = "ACTU";
                  _postsFuture = _loadPosts(categorie: "ACTU");
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Humour", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  _categorie = "HUMOUR";
                  _postsFuture = _loadPosts(categorie: "HUMOUR");
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Culture", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  _categorie = "CULTURE";
                  _postsFuture = _loadPosts(categorie: "CULTURE");
                });
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Divider(color: Colors.grey, thickness: 1),
            ListTile(
              leading: Icon(Icons.local_fire_department_outlined),
              title: Text("GudBox", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GudBoxScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_events_outlined),
              title: Text("Hall of Fame", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TopUsersScreen()));
              },
            ),
            Divider(color: Colors.grey, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red,),
              title: Text("Déconnexion", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
              onTap: () async {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/connexion',
                        (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {

          // État 1 : en cours de chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // État 2 : une erreur est survenue
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          // État 3 : les données sont là
          // Le Flare n'est affiché qu'en TOP, en premier élément de la liste (il défile avec le feed)
          final showFlare = _categorie == "TOP" && _flare != null;
          final offset = showFlare ? 1 : 0;

          if (_posts.isEmpty && !showFlare) {
            return const Center(child: Text('Aucun post pour le moment.'));
          }

          return RefreshIndicator(
              onRefresh: _onRefresh,




            child: ListView.builder(
                controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _posts.length + offset,
              itemBuilder: (context, index) {

              if (showFlare && index == 0) {
                return Opacity(
                  opacity: _opacity,
                  child: FlareCard(post: _flare!, onSparkToggled: _onSparkToggled, title: "🔥 Flare du moment"),
                );
              }

              return

                Opacity(
                    opacity: _opacity,
                    child:
                    PostCard(
                post: _posts[index - offset],
                onSparkToggled: _onSparkToggled,
              ));
            },
          ));
        },
      ),



    );
  }
}