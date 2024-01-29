import 'dart:io';

import 'package:amigos_ver1/authentication/pageDecider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String imageUrl = '';

  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    firstName = (await getUserFirstName(user.email!))!;
    lastName = (await getUserLastName(user.email!))!;
    userName = (await getUserName(user.email!))!;
    setState(() {});
  }

  final user = FirebaseAuth.instance.currentUser!;

  //controllers

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();


  //Get user details
  Future<String?> getUserFirstName(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['first name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<String?> getUserLastName(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['last name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<String?> getUserName(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['username'];
    } catch (e) {
      return 'Error fetching user';
    }
  }


  //replacing new details
  Future updateUserDetails(String firstName, String lastName, String email,
      String username) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection(
          'users');
      await users.doc(email).set({
        'first name': firstName,
        'last name': lastName,
        'username': username
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  //Info Updater
  Future infoUpdater() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.9),
        builder: (context) {
          return AlertDialog(
            title: const Text("update Details?"),
            content: const Text(
                "The application needs to be restarted to update information"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    if (firstNameController.text == "") {
                      firstNameController.text = firstName;
                    }
                    if (lastNameController.text == "") {
                      lastNameController.text = lastName;
                    }
                    if (userNameController.text == "") {
                      userNameController.text = userName;
                    }
                    updateUserDetails(firstNameController.text.trim(),
                        lastNameController.text.trim(), user.email!,
                        userNameController.text.trim());
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => Decider()));
                    Fluttertoast.showToast(
                        msg: "Information updated successfully",
                        fontSize: 18,
                        timeInSecForIosWeb: 5);
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  File? _imageFile;

  //upload photo
  Future uploadPhoto() async {
    final firebaseStorage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text("Please add an image!"));
          });
    } else {
      final imageTemp = File(imageFile.path);

      setState(() async {
        _imageFile = imageTemp;
        if (_imageFile != null) {
          //Upload to Firebase
          await firebaseStorage.ref()
              .child('user_profile_pictures/${user.email}.png')
              .putFile(_imageFile!);
          imageUrl = getDownloadURL('user_profile_pictures/${user.email}.png') as String;
          //imageUrl = await storageRef.child('user_profile_pictures/${user.email}.png').getDownloadURL();
        } else {
          print('No Image Path Received');
        }
      });
    }
  }

  Future<String> getDownloadURL(String fileName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
          elevation: 0,
          title: const Text("EDIT PROFILE", style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0
          )),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 40.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                          radius: 70.0,
                          backgroundColor: Colors.white,
                          child: imageUrl != '' ? Image.network(
                              imageUrl, width: 150,
                              height: 150,
                              fit: BoxFit.cover) : Image.asset(
                              'assets/logo.png')
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: GestureDetector(
                          onTap: uploadPhoto,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                color: const Color.fromRGBO(24, 22, 106, 1)
                            ),
                            child: const Icon(
                              Icons.edit, color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    height: 530,
                    width: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color.fromRGBO(175, 173, 248, 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text("Profile Details", style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w800,
                          ),),
                          const SizedBox(height: 20.0,),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("First Name", style: TextStyle(
                                color: Color.fromRGBO(45, 87, 124, 1),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: firstName
                            ),
                            enabled: true,
                          ),
                          SizedBox(height: 20.0,),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Last Name", style: TextStyle(
                                color: Color.fromRGBO(45, 87, 124, 1),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: lastName
                            ),
                            enabled: true,
                          ),
                          const SizedBox(height: 20.0,),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Username", style: TextStyle(
                                color: Color.fromRGBO(45, 87, 124, 1),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          const SizedBox(height: 10.0,),
                          TextFormField(
                            controller: userNameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: userName
                            ),
                            enabled: true,
                          ),
                          const SizedBox(height: 20.0,),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("E-mail Address", style: TextStyle(
                                color: Color.fromRGBO(45, 87, 124, 1),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                          const SizedBox(height: 10.0,),
                          TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: user.email,
                                hintStyle: TextStyle(
                                    color: Colors.black
                                )
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 25.0,),
                          ElevatedButton(
                            onPressed: () {
                              infoUpdater();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                    24, 22, 106, 1),
                                padding: const EdgeInsets.fromLTRB(
                                    105.0, 10.0, 105.0, 10.0),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                )
                            ),
                            child: const Text(
                              "Edit Profile",
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
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
