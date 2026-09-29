import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../widgets/flare_card.dart';
import '../models/post.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';


class GudBoxScreen extends StatefulWidget {
  const GudBoxScreen({super.key});

  @override
  State<GudBoxScreen> createState() => _GudBoxScreenState();
}


class _GudBoxScreenState extends State<GudBoxScreen> {

  // Le client HTTP — à déclarer une seule fois dans la classe
  final Dio _dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
  ));

  late Future<List<Post>> _postsFuture;
  List<Post> _posts = [];


  @override
  void initState() {
    super.initState();
    _postsFuture = _loadPosts();
  }

  Future<List<Post>> _loadPosts() async {
    final posts = await getGudBox();
    setState(() => _posts = posts);
    return posts;
  }

  Future<void> _onRefresh() async {
    final posts = await getGudBox();
    setState(() => _posts = posts);
  }

  // Même logique que le feed : on garde la liste locale à jour après un Spark
  void _onSparkToggled(Post updatedPost) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) _posts[index] = updatedPost;
    });
  }

  Future<List<Post>> getGudBox() async {
    try {
      final token = await AuthService().getToken();
      final response = await _dio.get(
        '/flare/gudbox',
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
        title: Text("GudBox", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          if (_posts.isEmpty) {
            return const Center(child: Text("Aucun Flare n'a encore été élu. Allez, à vos Sparks !"));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                // FlareCard réutilise PostCard (qui gère déjà le tap → DetailsScreen) + le halo animé
                return FlareCard(
                  post: _posts[index],
                  onSparkToggled: _onSparkToggled,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
