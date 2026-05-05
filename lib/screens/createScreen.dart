import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../screens/userProfileScreen.dart';

import 'package:gudnuz/theme/colors.dart';


class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool isLiked = false;
  int sparkCount = 245;
  int _currentIndex = 1;

  String _selectedCategory = 'Actualités';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2EDE1),
        appBar: AppBar(
          title: const Text('Poster', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      body:  SingleChildScrollView(
        child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Center(
                child: Text(
                  'catégories',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [





                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(

                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Actualités';
                      });

                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),

                      backgroundColor: _selectedCategory == 'Actualités' ? Colors.black : Colors.white,
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Actualités', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: _selectedCategory == 'Actualités' ? kYellow : Colors.black,
                    )),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(

                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Humour';
                      });

                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 3),

                      backgroundColor: _selectedCategory == 'Humour' ? Colors.black : Colors.white,

                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Humour', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: _selectedCategory == 'Humour' ? kYellow : Colors.black,)),
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(

                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'Culture';
                      });

                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),

                      backgroundColor: _selectedCategory == 'Culture' ? Colors.black : Colors.white,

                      side: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Culture', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,   color: _selectedCategory == 'Culture' ? kYellow : Colors.black,)),
                  ),
                )










              ],
            ),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),

                  child: TextField(
                    maxLines: null,
                    maxLength: 90,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, height: 1.0, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Il s'est passé quoi de beau aujourd'hui ?",
                      hintStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, height: 1.0, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),


                SizedBox(
                  height: 220,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      maxLines: null,
                     // maxLength: 500,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, height: 1.0, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Mets de la lumière dans les yeux des utilisateurs !",
                        hintStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, height: 1.0, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left:30, top: 10),
                  child: Text("Source obligatoire pour les actualités :",

                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 0.6, color: Colors.black)),
                ),
                Padding(
                      padding: const EdgeInsets.only(top:10, left: 30),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          SizedBox(
                            width: 270,
                            child: Expanded(

                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                               Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [

                                      Expanded(
                                        child: TextField(
                                          maxLines: null,
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.0, color: Colors.black),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 1),
                                            hintText: "Ton pote Seb n'est pas une source",
                                            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.0, color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            ),
                          ),


                              Container(

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.add_a_photo, size: 35),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),


                              ),


                        ],
                      ),
                ),






                  Padding(
                    padding: const EdgeInsets.only(top:10, left:30, right:30),
                    child: Center (
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(

                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),

                              backgroundColor: Colors.black,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Poster', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: kYellow)),
                          ),
                        ),

                    ),
                  )






              ],
            ),

          ],


        ),
      ),
    ),

  );
  }
}