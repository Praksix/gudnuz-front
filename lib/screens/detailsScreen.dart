import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gudnuz/services/auth_service.dart';
import '../screens/userProfileScreen.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/date_utils.dart';


class DetailsScreen extends StatefulWidget {
  final Post post;
  const DetailsScreen({super.key, required this.post});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLiked = false;
  late int sparkCount;

  final TextEditingController _motifController = TextEditingController();
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    sparkCount = widget.post.sparksCount;
    isLiked = widget.post.isSparked;
    _userFuture = _loadUser();
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));


  Future<User> _loadUser() async {
    final user = await getUser();
    return user;
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

  Future<void> _reportPost() async {
    if (_motifController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le motif est obligatoire')),
      );
      return;
    }




    try {
      final token = await AuthService().getToken();
      await _dio.post(
        '/posts/${widget.post.id}/report',
        data: {'motif': _motifController.text},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _motifController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signalement envoyé, merci !')),
      );

    } on DioException catch (e) {
      if (!mounted) return;
      final message = e.response?.statusCode == 409
          ? 'Tu as déjà signalé ce post'
          : 'Une erreur est survenue, réessaie plus tard';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }



  Future<void> _removePost() async {

    try {
      final token = await AuthService().getToken();
      await _dio.patch(
        '/moderation/posts/${widget.post.id}/remove',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post Supprimé avec succès')),
      );
      Navigator.pop(context);

    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Une erreur est survenue, réessaie plus tard')));
    }
  }






  Future<void> toggleSpark() async {
    setState(() {
      isLiked = !isLiked;
      isLiked ? sparkCount++ : sparkCount--;
    });

    try {
      final token = await AuthService().getToken();
      final response = await _dio.post(
        '/posts/${widget.post.id}/spark',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() => sparkCount = response.data['sparksCount'] as int);
    } on DioException catch (_) {
      setState(() {
        isLiked = !isLiked;
        isLiked ? sparkCount++ : sparkCount--;
      });
    }
  }


@override
  void dispose() {
    _motifController.dispose();
    super.dispose();
  }

  // Retourne le post mis à jour quand l'écran se ferme
  Post get _updatedPost => widget.post.copyWith(
    isSparked: isLiked,
    sparksCount: sparkCount,
  );

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return PopScope(
        canPop: false,
      // Quand l'utilisateur appuie sur retour, on retourne le post mis à jour
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).pop(_updatedPost);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF2EDE1),
        appBar: AppBar(
          title: Text(post.categorie, style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // Retourne le post mis à jour au lieu du pop normal
            onPressed: () => Navigator.pop(context, _updatedPost),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(

          ),
          child: SingleChildScrollView(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
                children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserProfileScreen(userId: post.userId)),
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: (post.avatarUrl != null
                            ? NetworkImage(post.displayAvatarUrl!)
                            : AssetImage('assets/images/pp.jpg')
                        ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(post.titre,  style: TextStyle(fontSize: 20, height: 1.0, fontWeight: FontWeight.w700, )),
                        Text("@${post.pseudo}",  style: TextStyle(fontSize: 14, height: 1.0, fontWeight: FontWeight.w300, )),
                      ]
                    ),
                  ),
                )

              ]

            ),
          ),



          // Image — affichée uniquement si elle existe
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(post.displayImageUrl!, fit: BoxFit.cover)  ,
            ),


          Padding(
            padding: const EdgeInsets.only(top:10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.contenu,

                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto",
                    )
                ),
                const SizedBox(height: 20),

                Text(formatTimeAgo(post.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w200,
                    )
                ),





                /**Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text("Lire en entier",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          //fontFamily: "Roboto",
                        )
                    ),
                  ),
                )**/
              ]

            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


                // Source — affichée uniquement pour les posts ACTU et si elle existe
                if (post.source != null)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            Icon(Icons.language, size: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                post.source!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(width: 10),
                //Toggle Spark
            GestureDetector(
                onTap: toggleSpark,
              child:
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Image.asset(isLiked ? 'assets/images/ys.png' : 'assets/images/es.png'),
                            const SizedBox(width: 7),
                            Text("$sparkCount",
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                )
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )
            )

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:10),
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),

          Center(
              child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFFF2EDE1),  // même fond que ton écran
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          title: Text('Signaler ce contenu'),
                          content: TextField(
                            controller: _motifController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Décris le motif...',
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
                                Navigator.pop(context);
                                _reportPost();
                              },
                              child: Text('Envoyer', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                  ),
                  child: const Text('Signaler',style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  )),
              ),
          ),

          FutureBuilder<User>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final user = snapshot.data!;
              if (user.role != 'ADMIN' && user.role != 'MODERATOR') return const SizedBox();
              return Center(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFFF2EDE1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          title: Text('Gérer le post'),
                          content: Text('Cette action retire le post pour tous les utilisateurs.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('annuler', style: TextStyle(color: Colors.grey)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _removePost();
                              },
                              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                            )
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                  ),
                  child: const Text('gérer ce post', style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  )),
                ),
              );
            },
          ),

        ],


            ),

          ),
                    ]

            ),
      ),
    ),

  ));
  }
}