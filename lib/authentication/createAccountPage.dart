import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccount extends StatefulWidget {
  final VoidCallback showLoginPage;
  const CreateAccount({super.key, required this.showLoginPage});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  //Controllers

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  //createUser
  void createUser()async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        addUserDetails(
            firstNameController.text.trim(), lastNameController.text.trim(),
            emailController.text.trim(), usernameController.text.trim());
        Fluttertoast.showToast(
            msg: "${user?.email} created successfully",
            fontSize: 18,
            timeInSecForIosWeb: 5);
      }else{
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Passwords do not match", textAlign: TextAlign.center,),
              );
            });
      }
    } on FirebaseAuthException catch(e){
      if (e.code == "invalid-email"){
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

  //add UserDetails to database
  Future addUserDetails(String firstName,String lastName, String email, String username) async{
    try{
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(email).set({
        'first name': firstName,
        'last name': lastName,
        'email' : email,
        'username' : username
      });
      return 'success';
    }catch (e){
      return 'Error adding user';
    }

  }

  //checking password
  bool passwordConfirmed(){
    if (passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(214, 217, 244, 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0,60.0,30.0,30.0),
            child: Column(
              children: [
                Image.asset("assets/logo.png",width: 150, height: 150,),
                const Text("CREATE ACCOUNT",
                  style:TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(9, 25, 81, 1),
                  ),),
                const SizedBox(height: 50.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("FIRST NAME",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,

                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 20.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("LAST NAME",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,

                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 20.0,),
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
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 20.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("USER NAME",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,

                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
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
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 20.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text("CONFIRM PASSWORD",style: TextStyle(
                    fontSize: 15.0,
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontWeight: FontWeight.w500,

                  ),),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none
                      ),
                      fillColor: const Color.fromRGBO(104, 100, 247, 1),
                      filled: true,
                  ),
                  cursorColor: const Color.fromRGBO(141, 116, 116, 1),
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                const SizedBox(height: 50.0,),
                ElevatedButton(
                  onPressed: (){
                    createUser();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                      padding: const EdgeInsets.fromLTRB(140.0, 20.0, 140.0, 20.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                const SizedBox(height: 80.0,),
                const Text("Already have an account ?",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),),
                const SizedBox(height: 10.0,),
                GestureDetector(
                  onTap: widget.showLoginPage,
                  child: const Text(
                    "LOG IN",
                    style: TextStyle(
                        color: Color.fromRGBO(104, 100, 247, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0
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
