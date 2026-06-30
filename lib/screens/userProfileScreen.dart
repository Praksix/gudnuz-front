import 'dart:ffi';
import 'package:dio/dio.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import 'package:gudnuz/theme/colors.dart';
import '../services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {

  final String? userId;
  UserProfileScreen({super.key, this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {

  // Le client HTTP — à déclarer une seule fois dans la classe
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api', // émulateur Android
  ));

  late Future<User> _userFuture;
  late Future<List<Post>> _postsFuture;
  List<Post> _posts = [];



  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
    _postsFuture = _loadPosts();
  }


  Future<User> _loadUser({String? id}) async {
    try {
      final token = await AuthService().getToken();
      final url = widget.userId != null ? '/users/${widget.userId}' : '/users/me';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return User.fromJson(response.data);

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }


  Future<List<Post>> _loadPosts({String? id}) async {
    try {
      final token = await AuthService().getToken();
      final url = widget.userId != null ? '/users/${widget.userId}/posts' : '/posts/me';
      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data;
      final posts = data.map((json) => Post.fromJson(json)).toList();
      setState(() => _posts = posts);
      return posts;

    } on DioException catch (e) {
      throw Exception('Erreur réseau : ${e.message}');
    }
  }


  void _onSparkToggled(Post updatedPost) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == updatedPost.id);
      if (index != -1) _posts[index] = updatedPost;
    });
  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2EDE1),
        appBar: AppBar(
          title: const Text('Profil', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<User>(
          future: _userFuture,
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
            final user = snapshot.data!;

            return
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(

                ),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(

                          // height: 400,
                          decoration: BoxDecoration(
                            color: kYellow,
                            border: Border(
                              top: BorderSide(color: Colors.black, width: 1),
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),

                          ),


                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, bottom: 15),

                            child: Column(
                              children: [
                              Row(

                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/pp.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(user.pseudo, style: TextStyle(fontSize: 24,
                                        height: 1.1,
                                        fontWeight: FontWeight.w700)),
                                    Text(user.userLevel,
                                        style: TextStyle(fontSize: 17,
                                            height: 1.1,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),


                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Text(user.postsCount.toString(), style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800, color: Colors.black)),
                                              Text("Nuz", style: TextStyle(
                                                  fontSize: 16,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black)),
                                            ],
                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Text(user.sparksCount.toString(), style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800, color: Colors.black)),
                                              Text("Sparks", style: TextStyle(
                                                  fontSize: 16,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black)),
                                            ],
                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            children: [
                                              Text(user.flaresCount.toString(), style: TextStyle(
                                                  fontSize: 22,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black)),
                                              Text("Flares", style: TextStyle(
                                                  fontSize: 16,
                                                  height: 1.3,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black)),
                                            ],


                                          ),

                                        ),


                                      ],


                                    )


                                    //Text("Dealer de Good Vibes", style: TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w600, color: Colors.white)),

                                  ],
                                ),


                              ],


                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, right: 15),
                                child: Text(user.bio ?? " ",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          ]),


                        ),




                        //PostCard(),


                        ),

                        FutureBuilder<List<Post>>(
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

                            if (_posts.isEmpty) {
                              return const Center(child: Text('Aucun post pour le moment.'));
                            }

                            return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _posts.length,
                                  itemBuilder: (context, index) {
                                    return PostCard(
                                      post: _posts[index],
                                      onSparkToggled: _onSparkToggled,
                                    );
                                  },
                                );
                          },
                        ),


                      ]),
                ),

              )
            ;

          }));
  }
}