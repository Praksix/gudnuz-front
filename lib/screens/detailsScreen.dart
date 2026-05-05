import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../screens/userProfileScreen.dart';
import '../models/post.dart';

class DetailsScreen extends StatefulWidget {
  final Post post;
  const DetailsScreen({super.key, required this.post});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLiked = false;
  late int sparkCount;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    sparkCount = widget.post.sparks;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
        backgroundColor: Color(0xFFF2EDE1),
        appBar: AppBar(
          title: const Text('Actus', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                    MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
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
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(post.titre,  style: TextStyle(fontSize: 20, height: 1.0, fontWeight: FontWeight.w700, )),
                        Text("@${post.auteur}",  style: TextStyle(fontSize: 14, height: 1.0, fontWeight: FontWeight.w300, )),
                      ]
                    ),
                  ),
                )

              ]

            ),
          ),



          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/images/party.jpg'),
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

                Text("Il y a 2h et 13min",
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
                          Text("http://lemonde.fr",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
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

                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                  ),
                  child: const Text('Signaler',style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ))
              )
          )


        ],
            ),
          ),
        ]),
      ),
    ),

  );
  }
}