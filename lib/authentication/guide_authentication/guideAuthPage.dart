
import 'package:amigos_ver1/authentication/guide_authentication/guideCreateAccountPage.dart';
import 'package:amigos_ver1/authentication/guide_authentication/guideLoginPage.dart';
import 'package:amigos_ver1/authentication/traveller_authentication/userCreateAccountPage.dart';
import 'package:amigos_ver1/authentication/userTypeSelector.dart';
import 'package:flutter/material.dart';

class GuideAuthPage extends StatefulWidget {
  const GuideAuthPage({super.key});

  @override
  State<GuideAuthPage> createState() => _GuideAuthPageState();
}

class _GuideAuthPageState extends State<GuideAuthPage> {

  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return GuideLogin(showRegisterPage: toggleScreens);
    }
    return GuideCreateAccount(showLoginPage: toggleScreens);
  }
}
