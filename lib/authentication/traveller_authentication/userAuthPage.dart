import 'package:amigos_ver1/authentication/traveller_authentication/userCreateAccountPage.dart';
import 'package:flutter/material.dart';
import 'userLoginPage.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {

  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
}

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return UserLogIn(showRegisterPage: toggleScreens);
    }
    return UserCreateAccount(showLoginPage: toggleScreens);
}
}
