import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gudnuz/theme/colors.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';


class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _contenuController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();


  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  String _selectedCategory = 'Actualités';
  File? _imageFile;




Future<void> _pickImage() async {
  final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080, // redimensionne avant envoi (photos iPhone = plusieurs Mo)
      imageQuality: 80,
    );
  if (picked != null){
    setState(() =>  _imageFile = File(picked.path));
  }
}
void _deleteImage() {
  setState(() =>  _imageFile = null);
}


  Future<void>  _createPost() async {

    try {
      final formData = FormData.fromMap({
        'titre': _titreController.text,
        'contenu': _contenuController.text,
        'categorie': {
          'Actualités': 'ACTU',
          'Humour': 'HUMOUR',
          'Culture': 'CULTURE',
        }[_selectedCategory],
        if (_selectedCategory == 'Actualités') 'source': _sourceController.text,
        if (_imageFile != null) 'image': await MultipartFile.fromFile(_imageFile!.path, filename: 'image.jpg',
        ),
      });

      await ApiService.dio.post(
        '/posts',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      _titreController.clear();
      _contenuController.clear();
      _sourceController.clear();

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main');

    } on DioException catch (e) {
      print('Erreur : ${e.message}');
      print('Réponse : ${e.response?.data}');
    }

  }










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

                  child: TextField( controller: _titreController,
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
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField( controller: _contenuController,
                      maxLines: null,
                     // maxLength: 500,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, height: 1.0, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Mets de la lumière dans les yeux des utilisateurs !",
                        hintStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, height: 1.0, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                ),

                  GestureDetector (
                    onTap: _pickImage,
                    child:
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 30),
                      child: Icon(Icons.add_a_photo, size: 35),
                    ),
                  ),

    ),

                  if (_imageFile != null)

                    Padding(
                      padding: const EdgeInsets.only(left:30, right: 30, top: 10, bottom: 20),
                      child: Stack(
                        children: [
                          Image.file(_imageFile!),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child:

                            GestureDetector (
                              onTap: _deleteImage,
                              child:
                            Icon(Icons.close, size: 35, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_selectedCategory == 'Actualités')
                    Padding(
                  padding: const EdgeInsets.only(left:30, top: 10),
                  child: Text("Source obligatoire pour les actualités :",

                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 0.6, color: Colors.black)),
                ),

                if (_selectedCategory == 'Actualités')
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _sourceController,
                          maxLines: null,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.0, color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            hintText: "Ton coloc n'est pas une source",
                            hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.0, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),








                  Padding(
                    padding: const EdgeInsets.only(top:10, left:30, right:30),
                    child: Center (
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(

                            onPressed: _createPost,
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
  );
  }
}