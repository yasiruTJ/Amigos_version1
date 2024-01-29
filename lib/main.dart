import 'package:amigos_ver1/authentication/pageDecider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions
      (apiKey: "AIzaSyDwRlQTKSRY9zniwMgesDnwXiIDLDsfSeU",
        appId: "1:415005226316:android:c80b22b37f83694f2c8be9",
        messagingSenderId: "415005226316",
        projectId: "amigos-699a6",
      storageBucket: "gs://amigos-699a6.appspot.com/"
    ),
  );
  await Firebase.initializeApp();
  runApp(const ProviderScope(
      child: Main()
  ));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: AnimatedSplashScreen(
        splash: const SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.share_location_sharp,
                color: Color.fromRGBO(195, 234, 109, 1),
                size: 40.0,
              ),
              Text("AMIGOS",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 35.0,
                  color: Color.fromRGBO(195, 234, 109, 1),
                ),)
            ],
          ),
        ),
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const Decider(),)
    );
  }
}
