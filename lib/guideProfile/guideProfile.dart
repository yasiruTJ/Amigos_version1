import 'package:amigos_ver1/authentication/guide_authentication/guideDeleteAccountPage.dart';
import 'package:amigos_ver1/authentication/guide_authentication/guidePageDecider.dart';
import 'package:amigos_ver1/guideProfile/guideEditProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class GuideProfile extends StatefulWidget {
  const GuideProfile({super.key});

  @override
  State<GuideProfile> createState() => _GuideProfileState();
}

class _GuideProfileState extends State<GuideProfile>{

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

//signOut
Future signOut(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.9),
      builder: (context){
        return AlertDialog(
          title: const Text("Log out?"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
                onPressed: ()=> Navigator.pop(context),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context)=> GuidePageDecider()));
                  Fluttertoast.showToast(
                      msg: "${user.email} logged out successfully",
                      fontSize: 18,
                      timeInSecForIosWeb: 5);
                },
                child: const Text("Logout"))
          ],
        );
      });
}

//Delete account
void delAccount(BuildContext context){
  Navigator.push(
      context,
      CupertinoPageRoute(builder: (context)=> const GuideDelAccount()));
}

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

Future<String?> getUserEmail(String email) async {
  try {
    CollectionReference users =
    FirebaseFirestore.instance.collection('guides');
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
          elevation: 0,
          title: const Text("PROFILE",style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0
          )),
          bottom: const TabBar(
            indicatorColor: Color.fromRGBO(175, 173, 248, 1),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(child: CircleAvatar(
                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                radius: 100,
                child: Icon(Icons.person_2_rounded,color: Color.fromRGBO(104, 100, 247, 1)),
              ),
              ),
              Tab(child: CircleAvatar(
                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                radius: 100,
                child: Icon(Icons.settings,color: Color.fromRGBO(104, 100, 247, 1)),
              ),
              ),
            ],
          ),

        ),
        body: TabBarView(children: [
          SingleChildScrollView(
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
                                padding: const EdgeInsets.fromLTRB(110.0,20.0,20.0,20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("$firstName $lastName",
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
                    const SizedBox(height: 40.0,),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color.fromRGBO(175, 173, 248, 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                padding: const EdgeInsets.all(8.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Align
                                  (
                                    alignment:Alignment.centerLeft,
                                    child: Text(user.email!)),
                              ),
                            ),
                            const SizedBox(height: 40.0,),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context)=>const GuideEditProfile()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  signOut(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                    padding: const EdgeInsets.fromLTRB(105.0, 15.0, 105.0, 15.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                ),
                child: const Text("Log Out",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),
              ),
              const SizedBox(height: 10.0,),
              ElevatedButton(
                onPressed: (){
                  delAccount(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                    padding: const EdgeInsets.fromLTRB(105.0, 15.0, 105.0, 15.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )
                ),
                child: const Text("Delete Account",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
