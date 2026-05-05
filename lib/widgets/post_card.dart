import 'package:flutter/material.dart';
import '../screens/detailsScreen.dart';
import '../screens/userProfileScreen.dart';
import '../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  late int sparkCount;

  @override
  void initState() {
    super.initState();
    sparkCount = widget.post.sparks;
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
                    MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage('assets/images/pp.jpg'),
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
                        Text("@${post.auteur}", style: TextStyle(fontSize: 12, height: 1.7, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image + contenu + actions — cliquable vers DetailsScreen
          GestureDetector(
            onTap: () => Navigator.push(
              context,
                MaterialPageRoute(builder: (_) => DetailsScreen(post: post))

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/party.jpg',
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
                        "Il y a 2h et 13min",
                        style: TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w200),
                      ),

                      // Toggle Spark — son propre GestureDetector prend la priorité
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                            isLiked ? sparkCount++ : sparkCount--;
                          });
                        },
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