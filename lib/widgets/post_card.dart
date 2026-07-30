import 'package:flutter/material.dart';
import '../screens/detailsScreen.dart';
import '../screens/userProfileScreen.dart';
import '../models/post.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';
import '../utils/date_utils.dart';


class PostCard extends StatefulWidget {
  final Post post;
  final Function(Post) onSparkToggled; // callback vers le parent

  const PostCard({super.key, required this.post, required this.onSparkToggled});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  late int sparkCount;

  @override
  void initState() {
    super.initState();
    sparkCount = widget.post.sparksCount;
    isLiked = widget.post.isSparked;
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    isLiked = widget.post.isSparked;
    sparkCount = widget.post.sparksCount;
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api'));

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
      final newCount = response.data['sparksCount'] as int;
      setState(() => sparkCount = newCount);
      widget.onSparkToggled(
        widget.post.copyWith(isSparked: isLiked, sparksCount: newCount),
      );
    } on DioException catch (_) {
      setState(() {
        isLiked = !isLiked;
        isLiked ? sparkCount++ : sparkCount--;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Header (avatar + titre) — non cliquable
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [

                GestureDetector(
                onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfileScreen(userId: post.userId)),
    ),
                  child: Container(
                    width: 50,
                    height: 50,
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
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.titre, style: TextStyle(fontSize: 16, height: 0.8, fontWeight: FontWeight.w800)),
                        Text("@${post.pseudo}", style: TextStyle(fontSize: 12, height: 1.7, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image + contenu + actions — cliquable vers DetailsScreen
          GestureDetector(
            onTap: () async {
              final currentPost = widget.post.copyWith(isSparked: isLiked, sparksCount: sparkCount);
              final updatedPost = await Navigator.push<Post>(
                context,
                MaterialPageRoute(builder: (_) => DetailsScreen(post: currentPost)),
              );
              if (updatedPost != null) {
                setState(() {
                  isLiked = updatedPost.isSparked;
                  sparkCount = updatedPost.sparksCount;
                });
                widget.onSparkToggled(updatedPost);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.imageUrl != null)
                  SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(post.displayImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    post.contenu,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTimeAgo(post.createdAt),
                        style: TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w200),
                      ),

                      // Toggle Spark — son propre GestureDetector prend la priorité
                      GestureDetector(
                        onTap: toggleSpark,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            child: Row(
                              children: [
                                Image.asset(isLiked ? 'assets/images/ys.png' : 'assets/images/es.png'),
                                const SizedBox(width: 7),
                                Text(
                                  "$sparkCount",
                                  style: TextStyle(fontSize: 15, height: 1.2, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Divider(color: Colors.grey, thickness: 1),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}