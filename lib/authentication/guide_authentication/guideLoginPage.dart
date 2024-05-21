
import 'package:amigos_ver1/authentication/guide_authentication/guideForgotPasswordPage.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class GuideLogin extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const GuideLogin({super.key, required this.showRegisterPage});

  @override
  State<GuideLogin> createState() => _GuideLoginState();
}

class _GuideLoginState extends State<GuideLogin> {

  final user = FirebaseAuth.instance.currentUser;

  //controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //signIn
  void signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("code error");
      print(e.code);
      if (e.code == 'invalid-credential') {
        _showAlertDialog(context, "Execution failed",
            "Invalid login credentials detected. Please check your email and password and try again");
      } else if (e.code == "invalid-email") {
        _showAlertDialog(context, "Execution failed",
            "The provided email address is badly formatted. Please make sure your email is valid. (sample@gmail.com)");
      } else if (e.code == "channel-error") {
        _showAlertDialog(context, "Execution failed",
            "All the text fields should be filled to proceed");
      }
    }
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  //guest access
  void guestTourGuideAccess(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Tour Guide Guest Access"),
            content: Text("Please note that you will not have access to following functionalities if you proceed as a guest. \n1. User profile customization\n2. Chat feature with tourists",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  height: 1.5
              ),),
            actions: [
              MaterialButton(
                onPressed: () {Navigator.pop(context);},
                child: Text("Cancel"),
              ),
              MaterialButton(
                onPressed: () {Navigator.push(context, CupertinoPageRoute(builder: (context)=> GuideDashboard() ));},
                child: Text("I Understand"),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(214, 217, 244, 1),
          foregroundColor: Color.fromRGBO(17, 15, 80, 1),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context)=> const Main()));
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Color.fromRGBO(17, 15, 80, 1),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0.0, screenWidth * 0.08, screenHeight * 0.00),
            child: Column(
              children: [
                Image.asset("assets/guide.png",width: 150, height: 150,),
                const Text("SIGN IN",
                  style:TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),),
                const SizedBox(height: 20.0,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("EMAIL",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,
                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: emailController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 16.0,
                      )
                  ),
                  cursorColor: Colors.white,
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 20.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("PASSWORD",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,

                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: passwordController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 16.0,
                      )
                  ),
                  cursorColor: Colors.white,
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton
                    (onPressed: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const GuideForgotPassword()
                      ),);
                  },
                    child: const Text(
                      "FORGOT PASSWORD ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: Color.fromRGBO(24, 22, 106, 1)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:10.0,),
                ElevatedButton(
                  onPressed: (){
                    signIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(17, 15, 80, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: const Text(
                      "LOG IN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                const SizedBox(height:15.0,),
                ElevatedButton(
                  onPressed: (){
                    guestTourGuideAccess();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(17, 15, 80, 1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: const Text(
                      "CONTINUE AS GUEST",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0,),
                const Text("Don't have an account yet ?",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),),
                const SizedBox(height: 10.0,),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: const Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      color: Color.fromRGBO(104, 100, 247, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
