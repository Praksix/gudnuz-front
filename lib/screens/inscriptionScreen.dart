import 'package:flutter/material.dart';
import 'package:gudbuz/theme/colors.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text("GUDNUZ", style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900, )),
               const SizedBox(height: 50),
              Image.asset('assets/images/black-spark.png'),
              const SizedBox(height: 50),


              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Column(
                      children: [
                        TextField(decoration: InputDecoration(hintText: 'Pseudo', hintStyle: TextStyle(color: Colors.grey), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), filled: true, fillColor: Colors.white,  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(6) )), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black )),
                        const SizedBox(height: 30),
                        TextField(decoration: InputDecoration(hintText: 'Email', hintStyle: TextStyle(color: Colors.grey), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), filled: true, fillColor: Colors.white,  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(6))), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black )),
                        const SizedBox(height: 30),
                        TextField(obscureText: true , decoration: InputDecoration(hintText: 'Mot de passe', hintStyle: TextStyle(color: Colors.grey), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), filled: true, fillColor: Colors.white,  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(6))), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black )),

                      ]
                    ),
                  )
                ],
              ),


              const SizedBox(height: 39),

              ElevatedButton(
                onPressed: () {
                  // action au clic
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 7),

                  backgroundColor: Colors.black,
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Inscription', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kYellow)),
              )


            ],
          )

      ),
    );
  }
}