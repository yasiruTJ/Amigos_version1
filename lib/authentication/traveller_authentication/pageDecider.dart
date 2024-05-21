
import 'package:amigos_ver1/customizers/customizeMain.dart';
import 'package:amigos_ver1/dashboardMain/dashboardPage.dart';
import 'package:amigos_ver1/dashboardMain/menuPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'userAuthPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Decider());
}

class Decider extends StatelessWidget {
  const Decider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder
        (
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if (snapshot.hasData){
              return const Menu();
            }else {
              return const UserAuthPage();
            }
          }
      ),
    );
  }
}
