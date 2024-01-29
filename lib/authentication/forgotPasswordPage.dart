import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  //Controllers

  final forgotPasswordEmailController = TextEditingController();

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
                const Text("FORGOT PASSWORD ?",
                  style:TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),),
                const SizedBox(height: 35.0,),
                const Text("Enter your email and we will send you a password reset link!",
                  style:TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),
                textAlign: TextAlign.center,
                maxLines: 3,),
                const SizedBox(height: 45.0,),
                TextFormField(
                  controller: forgotPasswordEmailController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                      hintText: "Email",
                      hintStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                      ),
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
                SizedBox(height: 50.0,),
                ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                      padding: const EdgeInsets.fromLTRB(90.0, 20.0, 90.0, 20.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  child: const Text(
                    "RESET PASSWORD",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(height: 280.0,),
              ],
            ),
          ),
        )
    );
  }
}
