
import 'package:flutter/material.dart';
import 'createAccountPage.dart';
import 'loginPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
}

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LogIn(showRegisterPage: toggleScreens);
    }
    return CreateAccount(showLoginPage: toggleScreens);
  }
}
