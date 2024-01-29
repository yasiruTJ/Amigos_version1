import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'authPage.dart';

class DelAccount extends StatefulWidget {
  const DelAccount({super.key});

  @override
  State<DelAccount> createState() => _DelAccountState();
}

class _DelAccountState extends State<DelAccount> {

  final user = FirebaseAuth.instance.currentUser!;

  //controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Delete firebase account
  Future delAccount(){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Delete your Account?"),
            content: const Text("If you select delete we will delete your account on our server.Your app data will also be deleted and you won't be able to retrieve it.Since this is a security-sensitive operation, you eventually are asked to login before your account can be deleted."),
            actions: [
              TextButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: ()async{
                    try{
          final user = FirebaseAuth.instance.currentUser;

          AuthCredential credential = EmailAuthProvider.credential(email: emailController.text.trim(), password: passwordController.text.trim());

          await user?.reauthenticateWithCredential(credential);

          await user?.delete();

          Navigator.pop(context);
          Navigator.push(
          context,
          CupertinoPageRoute(builder: (context)=> AuthPage()));
          Fluttertoast.showToast(
              msg: "${user?.email} deleted successfully",
              fontSize: 18,
              timeInSecForIosWeb: 5);
          } on FirebaseAuthException catch(e){
                      print(e);
          if (e.code == "INVALID_LOGIN_CREDENTIALS") {
            Navigator.pop(context);
          showDialog(
          context: context,
          builder: (context) {
          return const AlertDialog(
          title: Text("No user found", textAlign: TextAlign.center,),
          );
          });
          } else if (e.code == "invalid-email"){
            Navigator.pop(context);
          showDialog(
          context: context,
          builder: (context) {
          return const AlertDialog(
          title: Text("Email address is badly formatted",textAlign: TextAlign.center,),
          );
          });
          }else if (e.code == "channel-error"){
            Navigator.pop(context);
          showDialog(
          context: context,
          builder: (context) {
          return const AlertDialog(
          title: Text("Fill all the fields", textAlign: TextAlign.center,),
          );
          });
          }
          }
                  },
                  child: const Text("Delete"))
            ],
          );
        });
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
                Image.asset("assets/logo.png",width: 150, height: 150,),
                Text("DELETE ACCOUNT ?",
                  style:TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),),
                const SizedBox(height: 80.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("EMAIL",style: TextStyle(
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
