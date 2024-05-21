import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForgotPassword extends StatefulWidget {
  const UserForgotPassword({Key? key}) : super(key: key);

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {

  //Controllers
  final forgotPasswordEmailController = TextEditingController();

  Future<void> resetPassword() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgotPasswordEmailController.text.trim());

      Fluttertoast.showToast(
          msg: "Password reset email sent",
          fontSize: 18,
          timeInSecForIosWeb: 5);
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
  void dispose() {
    forgotPasswordEmailController.dispose();
    super.dispose();
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.1 * MediaQuery.of(context).size.width, 0.1 * MediaQuery.of(context).size.height, 0.1 * MediaQuery.of(context).size.width, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/amigos_logo.png", width: 0.4 * MediaQuery.of(context).size.width, height: 0.4 * MediaQuery.of(context).size.width,),
                 Text("FORGOT PASSWORD ?",
                  style:TextStyle(
                    fontSize: 0.06 * MediaQuery.of(context).size.width,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),),
                 SizedBox(height: 0.04 * MediaQuery.of(context).size.height,),
                 Text("Enter your email and we will send you a password reset link!",
                  style:TextStyle(
                    fontSize: 0.040 * MediaQuery.of(context).size.width,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,),
                SizedBox(height: 0.05 * MediaQuery.of(context).size.height,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: forgotPasswordEmailController,
                  decoration: InputDecoration(
                      contentPadding:  EdgeInsets.all(0.04 * MediaQuery.of(context).size.width),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.04 * MediaQuery.of(context).size.width),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                      hintText: "Email",
                      hintStyle:  TextStyle(
                          fontSize: 0.040 * MediaQuery.of(context).size.width,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
                      prefixIcon:  Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 0.029 * MediaQuery.of(context).size.width,
                      )
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                SizedBox(height: 0.06 * MediaQuery.of(context).size.height,),
                ElevatedButton(
                  onPressed: resetPassword,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                      padding: EdgeInsets.fromLTRB(0.25 * MediaQuery.of(context).size.width, 0.02 * MediaQuery.of(context).size.height, 0.25 * MediaQuery.of(context).size.width, 0.02 * MediaQuery.of(context).size.height),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.04 * MediaQuery.of(context).size.width),
                      )
                  ),
                  child: Text(
                    "RESET PASSWORD",
                    style: TextStyle(
                        fontSize: 0.04 * MediaQuery.of(context).size.width,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                 SizedBox(height: 0.28 * MediaQuery.of(context).size.height,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
