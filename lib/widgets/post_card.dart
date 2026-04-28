import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int sparkCount = 245;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/pp.jpg'),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text("Titre de la Nuz",  style: TextStyle(fontSize: 20, height: 1.0, fontWeight: FontWeight.w700, )),
                      Text("@UserName",  style: TextStyle(fontSize: 14, height: 1.0, fontWeight: FontWeight.w300, )),

                    ]

                  ),
                )

              ]

            ),
          ),



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
            padding: const EdgeInsets.only(top:10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus, elit vitae vulputate dapibus, leo elit porta felis, et ultricies libero lectus ac nisi. Curabitur lectus quam, varius luctus risus a, malesuada faucibus purus. Suspendisse nunc elit, molestie vel posuere ut, luctus sed felis. Suspendisse commodo, ligula non placerat vestibulum, ante elit efficitur est, fermentum tempor risus augue a eros. In feugiat, ipsum eget sodales elementum, risus urna dapibus magna, a convallis turpis tortor id ipsum. Sed dapibus, ligula ac rhoncus rutrum, nisi metus dignissim diam, vitae tempor erat lorem at massa. Nulla facilisi. Fusce eget semper massa. Nulla ut arcu non dui malesuada dapibus sit amet ut mi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam gravida efficitur consequat.",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto",
                    )
                ),
                const SizedBox(height: 10),

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
                Text("Il y a 2h et 13min",
                style: TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w200,
                )
                ),


                //Toggle Spark
            GestureDetector(
              onTap: () {
                setState(() {
                  isLiked = !isLiked;
                  isLiked ? sparkCount++ : sparkCount--;
                });
              },
              child:
                Container(
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
                        Text("$sparkCount",
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                            )
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
          )



        ],
      ),
    );
  }
}