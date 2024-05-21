import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'editProfile.dart';

class UserProfileDetailsGuide extends StatefulWidget {
  const UserProfileDetailsGuide({super.key});

  @override
  State<UserProfileDetailsGuide> createState() => _UserProfileDetailsGuideState();
}

class _UserProfileDetailsGuideState extends State<UserProfileDetailsGuide> {

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

  Future<String?> getUserEmail(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['email'];
    } catch (e) {
      return 'Error fetching user';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0,30.0,25.0,10.0),
          child: Center(
            child: Column(
              children: [
                Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 100.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color.fromRGBO(175, 173, 248, 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(110.0,20.0,20.0,20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(firstName + " "+ lastName,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(24, 22, 106, 1)
                                    ),),
                                ),
                                const SizedBox(height: 6.0,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("@$userName",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                    ),),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 0,
                        child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.white,
                            backgroundImage: imageExists
                                ? NetworkImage(imageUrl) // Use _imageFile if it's not null
                                : const NetworkImage("https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png")
                        ),
                      ),
                    ]
                ),
                SizedBox(height: 40.0,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.53,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromRGBO(175, 173, 248, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text("Profile Details",style: TextStyle(
                          fontSize: 18.0,
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w800,
                        ),),
                        const SizedBox(height: 30.0,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "First Name",
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 87, 124, 1),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(firstName),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "Last Name",
                                    style: TextStyle(
                                      color: Color.fromRGBO(45, 87, 124, 1),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(lastName),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0,),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Username",style: TextStyle(
                              color: Color.fromRGBO(45, 87, 124, 1),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600
                          ),),
                        ),
                        const SizedBox(height: 10.0,),
                        Container(
                          height: 35,
                          width: 320,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align
                              (
                                alignment:Alignment.centerLeft,
                                child: Text(userName)),
                          ),
                        ),
                        const SizedBox(height: 30.0,),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("E-mail Address",style: TextStyle(
                              color: Color.fromRGBO(45, 87, 124, 1),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600
                          ),),
                        ),
                        const SizedBox(height: 10.0,),
                        Container(
                          height: 35,
                          width: 320,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align
                              (
                                alignment:Alignment.centerLeft,
                                child: Text(user.email!)),
                          ),
                        ),
                        SizedBox(height: 40.0,),
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context)=>const EditProfile()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(24, 22, 106, 1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              )
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
