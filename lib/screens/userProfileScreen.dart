
import 'package:dio/dio.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import 'package:gudnuz/theme/colors.dart';
import '../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'changePasswordScreen.dart';

class UserProfileScreen extends StatefulWidget {


  final String? userId;
  const UserProfileScreen({super.key, this.userId});


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

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _deletePasswordController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    _bioController.dispose();
    _deletePasswordController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
    _postsFuture = _loadPosts();
  }

  Future<void> _deleteAccount() async {
    try {
      final token = await AuthService().getToken();
      await _dio.patch(
        '/users/me/delete',
        data: {'currentPassword': _deletePasswordController.text},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      await AuthService().logout();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/connexion', (route) => false);

    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _showDeleteAccountDialog() {
    _deletePasswordController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF2EDE1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: const Text('Supprimer mon compte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cette action est définitive. Confirme avec ton mot de passe.'),
            const SizedBox(height: 12),
            TextField(
              controller: _deletePasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleError(DioException e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("aaaaaaaaaa, mec, ça bug... Toute l'équipe (moi) est sur le coup, reviens dans quelques heures. C'est l'occasion de toucher de l'herbe !")),
    );
  }



  Future<User> _loadUser() async {
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


  Future<List<Post>> _loadPosts() async {
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



  Future<void>  _updateBio() async {

    try {
      final token = await AuthService().getToken();
      final formData = FormData.fromMap({
        'bio': _bioController.text,

      });

      await _dio.patch(
        '/users/me',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      _bioController.clear();

      setState(() {
        _userFuture = _loadUser();
      });

    } on DioException catch (e) {
      print('URL appelée : ${e.requestOptions.uri}');
      print('Erreur : ${e.message}');
      print('Réponse : ${e.response?.data}');
      _handleError(e);
    }

  }


  Future<void>  _updateAvatar() async {

    try {
      final token = await AuthService().getToken();
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_imageFile!.path, filename: 'image.jpg'),
      });

      await _dio.patch(
        '/users/me',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      setState(() {
        _userFuture = _loadUser();
      });

    } on DioException catch (e) {
      print('URL appelée : ${e.requestOptions.uri}');
      print('Erreur : ${e.message}');
      print('Réponse : ${e.response?.data}');
      _handleError(e);
    }

  }


  Future<void> _pickImage() async {
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
      _updateAvatar();
    }
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
          actions: [
            if (widget.userId == null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'password') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
                  } else if (value == 'delete') {
                    _showDeleteAccountDialog();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'password', child: Text('Modifier le mot de passe')),
                  const PopupMenuItem(value: 'delete', child: Text('Supprimer mon compte', style: TextStyle(color: Colors.red))),
                ],
              ),
          ],
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

                        Stack(
                          children: [
                            Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                image: DecorationImage(
                                                  image: (user.avatarUrl != null
                                                      ? NetworkImage(user.displayAvatarUrl!)
                                                      : AssetImage('assets/images/pp.jpg')
                                                  ) as ImageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            if (widget.userId == null)
                                              Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: _pickImage,
                                                child: const Icon(Icons.edit, size: 20, color: Colors.white),
                                              ),
                                            ),
                                          ],
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Padding(

                                      padding: const EdgeInsets.only(top: 10, right: 10),

                                      child: Text(user.bio ?? " ",
                                        style: TextStyle(fontSize: 15),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (widget.userId == null)

                              Positioned(
                              bottom: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  _bioController.text = user.bio ?? '';
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFFF2EDE1),  // même fond que ton écran
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        title: Text("ptdr t'es qui ?"),
                                        content: TextField(
                                          controller: _bioController,
                                          maxLength: 200,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText: 'Racontes pas trop ta life non plus',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Annuler', style: TextStyle(color: Colors.grey),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _updateBio();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Envoyer', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(Icons.edit, size: 18),
                              ),
                            ),
                          ],
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

          }
          )

    );

  }
}