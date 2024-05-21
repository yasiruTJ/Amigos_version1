import 'package:amigos_ver1/authentication/guide_authentication/guideAuthPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GuideDelAccount extends StatefulWidget {
  const GuideDelAccount({super.key});

  @override
  State<GuideDelAccount> createState() => _GuideDelAccountState();
}

class _GuideDelAccountState extends State<GuideDelAccount> {

  final user = FirebaseAuth.instance.currentUser!;

  //controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Delete firebase account
  Future<void> delAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete your Account?"),
          content: const Text(
            "If you select delete we will delete your account on our server. Your app data will also be deleted and you won't be able to retrieve it.",
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;

                  AuthCredential credential = EmailAuthProvider.credential(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  await user?.reauthenticateWithCredential(credential);
                  await user?.delete();

                  print(emailController.text);
                  var userDetails =
                  FirebaseFirestore.instance.collection("guides").doc(emailController.text);
                  await userDetails.delete();

                  // Navigate to the user authentication page
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(builder: (context) => GuideAuthPage()),
                  );

                  Fluttertoast.showToast(
                    msg: "${user?.email} deleted successfully",
                    fontSize: 18,
                    timeInSecForIosWeb: 5,
                  );
                } on FirebaseAuthException catch (e) {
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
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: const Color.fromRGBO(9, 25, 81, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,60.0,30.0,0.0),
            child: Column(
              children: [
                Image.asset("assets/amigos_logo.png",width: 150, height: 150,),
                const Text("DELETE ACCOUNT ?",
                  style:TextStyle(
                    fontSize: 30.0,
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
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
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
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  obscureText: true,
                ),
                const SizedBox(height: 60.0,),
                ElevatedButton(
                  onPressed: delAccount,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                      padding: const EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 20.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  child: const Text(
                    "DELETE ACCOUNT",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
