import 'package:flutter/material.dart';
import 'package:gudbuz/theme/colors.dart';
import 'connexionScreen.dart';
import 'inscriptionScreen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              const SizedBox(height: 10),
              Text("l’appli ultime ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, )),
              Text("anti doom scrolling", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, )),
              const SizedBox(height: 50),
              Image.asset('assets/images/black-spark.png'),
              const SizedBox(height: 50),
              Text("Pas d'IA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, )),
              Text("Pas d'algorithme", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, )),
              Text("Pas de fomo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, )),
              Text("Que de la positivité", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, )),

              const SizedBox(height: 90),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnexionScreen()),
                  );

                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 7),

                  backgroundColor: Colors.white,
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Connexion', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black )),
              ),


              const SizedBox(height: 39),

              ElevatedButton(

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InscriptionScreen()),
                    );


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