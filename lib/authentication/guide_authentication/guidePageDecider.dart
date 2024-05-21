
import 'package:amigos_ver1/authentication/guide_authentication/guideAuthPage.dart';
import 'package:amigos_ver1/customizers/customizeMain.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const GuidePageDecider());
}

class GuidePageDecider extends StatelessWidget {
  const GuidePageDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder
        (
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot) {
            if (snapshot.hasData){
              return const GuideDashboard();
            }else {
              return const GuideAuthPage();
            }
          }
      ),
    );
  }
}
