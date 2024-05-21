import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class UserCreateAccount extends StatefulWidget {
  final VoidCallback showLoginPage;
  const UserCreateAccount({Key? key, required this.showLoginPage});

  @override
  State<UserCreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<UserCreateAccount> {

  //Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  //createUser
  void createUser(BuildContext context)async {
    try {
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        addUserDetails(
            firstNameController.text.trim(), lastNameController.text.trim(),
            emailController.text.trim(), usernameController.text.trim());
        createFavouriteEntry();
      }else{
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Execution failed"),
                content: Text("Passwords do not match. Please check if you have entered the same password in both 'password' and 'confirm password' fields",textAlign: TextAlign.justify,style: TextStyle(
                    height: 1.5
                ),),
                actions: [
                  MaterialButton(
                    onPressed: () {Navigator.pop(context);},
                    child: Text("OK"),
                  ),
                ],
              );
            });
      }
    } on FirebaseAuthException catch(e){
      print(e.code);
      if (e.code == "invalid-email") {
        _showAlertDialog(context, "Account Creation failed",
            "The provided email address is badly formatted. Please make sure your email is valid. (sample@gmail.com)");
      } else if (e.code == "channel-error") {
        _showAlertDialog(context, "Account Creation failed",
            "All the text fields should be filled to proceed.");
      } else if(e.code == "email-already-in-use"){
        _showAlertDialog(context, "Account Creation failed",
            "Email address already in use. Please log in with your credentials.");
      }else if(e.code == "weak-password"){
        _showAlertDialog(context, "Account Creation failed",
            "Password should be at least 6 characters long.");
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

  void createFavouriteEntry()async{
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Specify the collection and document ID for the empty document
      CollectionReference usersCollection = firestore.collection('favourites');
      DocumentReference document = usersCollection.doc(emailController.text);

      // Create the empty document
      await document.set(Map<String, dynamic>());

      print('Empty document created successfully');
    } catch (e) {
      print('Error creating empty document: $e');
    }
  }

  //checking password
  bool passwordConfirmed(){
    if (passwordController.text.trim() == confirmPasswordController.text.trim()){
      return true;
    }else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Account Creation Failed"),
              content: const Text("Entered passwords do not match",textAlign: TextAlign.justify,style: TextStyle(
                  height: 1.5
              ),),
              actions: [
                MaterialButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text("OK"),
                ),
              ],
            );
          });
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
          foregroundColor: const Color.fromRGBO(17, 15, 80, 1),
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
            padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0.0, screenWidth * 0.08, screenHeight * 0.08),
            child: Column(
              children: [
                Image.asset("assets/traveller.png",width: screenWidth * 0.3, height: screenWidth * 0.3,),
                const SizedBox(height: 20.0,),
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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("PASSWORD",style: TextStyle(
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
                // Show error message below the TextFormField
                const SizedBox(height: 20.0,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
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
                  onPressed: () {
                    createUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(17, 15, 80, 1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: const Text(
                      "SIGN UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40.0,),
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
                ),
              ],
            ),
          ),
        )
    );
  }
}
