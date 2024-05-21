import 'package:amigos_ver1/authentication/userTypeSelector.dart';
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
      theme: ThemeData(),
      home: AnimatedSplashScreen(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        splash: Scaffold(
            backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
            body:Center(child: Image.asset("assets/amigos_logo.png",width: 300,height: 300,))
        ),
        duration: 5000,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const UserTypeSelector(),
      )
    );
  }
}
