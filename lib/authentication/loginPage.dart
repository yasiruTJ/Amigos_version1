
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forgotPasswordPage.dart';

class LogIn extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LogIn({super.key, required this.showRegisterPage});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final user = FirebaseAuth.instance.currentUser;

  //controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //signIn

  void signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    }on FirebaseAuthException catch(e){
      if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Invalid login credentials", textAlign: TextAlign.center,),
              );
            });
      } else if (e.code == "invalid-email"){
    showDialog(
    context: context,
    builder: (context) {
    return const AlertDialog(
    title: Text("Email address is badly formatted",textAlign: TextAlign.center,),
    );
    });
      }else if (e.code == "channel-error"){
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Fill all the fields", textAlign: TextAlign.center,),
              );
            });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 217, 244, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0,60.0,30.0,0.0),
          child: Column(
            children: [
            Image.asset("assets/logo.png",width: 150, height: 150,),
            const Text("SIGN IN",
              style:TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(9, 25, 81, 1),
              ),),
              const SizedBox(height: 80.0,),
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
                            builder: (context) => const ForgotPassword()
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
              const SizedBox(height:60.0,),
              ElevatedButton(
                  onPressed: (){
                    signIn();
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(17, 15, 80, 1),
                  padding: const EdgeInsets.fromLTRB(135.0, 20.0, 135.0, 20.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )
                ),
                  child: const Text(
                    "LOG IN",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
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
