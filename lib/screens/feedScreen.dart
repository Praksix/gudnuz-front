import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/post_card.dart';
import '../models/post.dart';
import '../services/auth_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  // Le client HTTP — à déclarer une seule fois dans la classe
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api', // émulateur Android
  ));

  late Future<List<Post>> _postsFuture;
  List<Post> _posts = [];
  final Set<String> _likedPostIds = {};


  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
  }

  List<Post> _applyLikedState(List<Post> posts) {
    if (_likedPostIds.isEmpty) return posts;
    return posts
        .map((p) => _likedPostIds.contains(p.id) ? p.copyWith(isSparked: true) : p)
        .toList();
  }

  Future<List<Post>> _loadPosts({String? categorie}) async {
    final posts = await getPosts(categorie: categorie);
    final merged = _applyLikedState(posts);
    setState(() => _posts = merged);
    return merged;
  }

  Future<void> _onRefresh() async {
    final cat = _categorie == "TOP" ? null : _categorie;
    final posts = await getPosts(categorie: cat);
    setState(() => _posts = _applyLikedState(posts));
  }

  void _onSparkToggled(Post updatedPost) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) _posts[index] = updatedPost;
      if (updatedPost.isSparked) {
        _likedPostIds.add(updatedPost.id);
      } else {
        _likedPostIds.remove(updatedPost.id);
      }
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
      return data.map((json) => Post.fromJson(json)).toList();

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
          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return const Center(child: Text('Aucun post pour le moment.'));
          }

          return RefreshIndicator(
              onRefresh: _onRefresh,




            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
              return PostCard(
                post: _posts[index],
                onSparkToggled: _onSparkToggled,
              );
            },
          ));
        },
      ),



    );
  }
}