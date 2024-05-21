import 'dart:io';

import 'package:amigos_ver1/authentication/guide_authentication/guidePageDecider.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class GuideEditProfile extends StatefulWidget {
  const GuideEditProfile({super.key});

  @override
  State<GuideEditProfile> createState() => _GuideEditProfileState();
}

class _GuideEditProfileState extends State<GuideEditProfile> {
  String imageUrl = '';

  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';
  bool imageExists = false;

  @override
  void initState() {
    super.initState();
    getData();
    getProfilePic();
    checkImageExistence().then((exists) {
      setState(() {
        imageExists = exists;
      });
    });
  }

  void getData() async {
    firstName = (await getUserFirstName(user.email!))!;
    lastName = (await getUserLastName(user.email!))!;
    userName = (await getUserName(user.email!))!;
    setState(() {});
  }

  void getProfilePic()async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('user_profile_pictures/${user.email}/profilePic.jpg');
    imageUrl = await ref.getDownloadURL();
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
      FirebaseFirestore.instance.collection('guides');
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
      FirebaseFirestore.instance.collection('guides');
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
      FirebaseFirestore.instance.collection('guides');
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
          'guides');
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
            title: const Text("Update Details?"),
            content: const Text(
              "The application needs to be restarted to update information. Are you sure you want to proceed?",textAlign: TextAlign.justify,style: TextStyle(
                height: 1.5
            ),),
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
                        CupertinoPageRoute(builder: (context) => GuideDashboard()));
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
  Future<void> uploadPhoto() async {
    final firebaseStorage = FirebaseStorage.instance;
    final storageRef = FirebaseStorage.instance.ref();

    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("No Image Detected!"),
            content: const Text(
              "Image cannot be identified. Please make sure that you have uploaded an image!",textAlign: TextAlign.justify,style: TextStyle(
                height: 1.5
            ),),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Exit the method if no image is selected
    }

    final imageTemp = File(imageFile.path);

    setState(() {
      _imageFile = imageTemp;
    });

    if (_imageFile != null){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Changes?"),
            content: const Text("You will be redirected to the main page for the changes to be applied."),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              MaterialButton(
                onPressed: () async{
                  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('user_profile_pictures/${user.email}/profilePic.jpg');
                  firebaseStorageRef.putFile(_imageFile!, SettableMetadata(contentType: 'image/jpeg'));
                  Navigator.pop(context);
                  setState(() {

                  });
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => GuidePageDecider()));
                },
                child: const Text("Update"),
              ),
            ],
          );
        },
      );
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

  Future<bool> checkImageExistence() async {
    try {
      Reference ref = FirebaseStorage.instance.ref('user_profile_pictures/${user.email}/profilePic.jpg');
      await ref.getDownloadURL();
      return true; // Image exists
    } catch (e) {
      return false; // Image does not exist
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
                          backgroundImage: imageExists
                              ? NetworkImage(imageUrl) // Use _imageFile if it's not null
                              : const NetworkImage("https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png")
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
                    height: MediaQuery.of(context).size.height * 0.65,
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
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                )
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
                              padding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height * 0.02,
                                horizontal: MediaQuery.of(context).size.width * 0.2,
                              ),
                              child: const Text(
                                "Edit Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500
                                ),
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
