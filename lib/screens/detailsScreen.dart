import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';


class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isLiked = false;
  int sparkCount = 245;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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



          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/images/party.jpg'),
          ),


          Padding(
            padding: const EdgeInsets.only(top:10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus, elit vitae vulputate dapibus, leo elit porta felis, et ultricies libero lectus ac nisi. Curabitur lectus quam, varius luctus risus a, malesuada faucibus purus. Suspendisse nunc elit, molestie vel posuere ut, luctus sed felis. Suspendisse commodo, ligula non placerat vestibulum, ante elit efficitur est, fermentum tempor risus augue a eros. In feugiat, ipsum eget sodales elementum, risus urna dapibus magna, a convallis turpis tortor id ipsum. Sed dapibus, ligula ac rhoncus rutrum, nisi metus dignissim diam, vitae tempor erat lorem at massa. Nulla facilisi. Fusce eget semper massa. Nulla ut arcu non dui malesuada dapibus sit amet ut mi. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam gravida efficitur consequat.",

                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w300,
                      fontFamily: "Roboto",
                    )
                ),
                const SizedBox(height: 20),


                    Container(
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
                    )


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
          ),
        ]),
      ),
    ),
    bottomNavigationBar: AppBottomNavBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
    ),
  );
  }
}