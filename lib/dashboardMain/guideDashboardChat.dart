import 'package:amigos_ver1/authentication/guide_authentication/guideAuthPage.dart';
import 'package:amigos_ver1/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../guideProfile/guideProfile.dart';

class GuideDashboardChat extends StatefulWidget {
  const GuideDashboardChat({super.key});

  @override
  State<GuideDashboardChat> createState() => _GuideDashboardChatState();
}

class _GuideDashboardChatState extends State<GuideDashboardChat> {
  String name = '';
  String? imageUrl;
  final user = FirebaseAuth.instance.currentUser;
  List<String> documentNames = [];
  Map<String, String> userImages = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  //Get user details
  Future<String?> getUser(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('guides');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['username'];
    } catch (e) {
      return 'Guest User';
    }
  }

  void getData() async {
    name = (await getUser(user?.email ?? "Guest User"))!;
    setState(() {});
  }

  Future<void> getAllUsers()async{
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await collectionRef.get(); // Retrieve documents

      // Iterate through the documents and extract the document IDs
      querySnapshot.docs.forEach((doc) {
        documentNames.add(doc.id); // Add document ID to the list
      });

      // Print or use the document names as needed
      print('Document names in the collection: $documentNames');
    } catch (e) {
      print('Error getting documents: $e');
    }

  }

    Future<String?> getProfilePic(String email) async {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final ref = storage.ref().child('user_profile_pictures/$email/profilePic.jpg');
      imageUrl = await ref.getDownloadURL();
      String? url = imageUrl ?? "";
      setState(() {
        userImages[email] = imageUrl!;
      });
      return url;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Color.fromRGBO(24, 22, 106, 1),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Hello, $name",
          style: const TextStyle(
              color: Color.fromRGBO(24, 22, 106, 1)
          ),
        ),
        actions: [
          if (name == 'Guest User')
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GuideAuthPage()),
                );
              },
              icon: Icon(Icons.exit_to_app, color: Color.fromRGBO(24, 22, 106, 1)),
            ),
          if (name != 'Guest User')
            IconButton(
              onPressed: () {
                // Navigate to the profile screen
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => GuideProfile()),
                );
              },
              icon: Icon(Icons.person, color: Color.fromRGBO(24, 22, 106, 1)),
            ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>
      (stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Text("error");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  // Circular progress indicator with a dashed appearance
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(24, 22, 106, 1)),
                  strokeWidth: 3.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Fetching incoming chats...",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1), fontSize: 15.0),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: name != 'Guest User' ? snapshot.data!.docs.length : 1, // Ensure the list has at least one item if name is 'Guest User'
          itemBuilder: (context, index) {
            if (name != 'Guest User') {
              return _buildUserListItem(snapshot.data!.docs[index]);
            } else {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,),
                    const Text(
                      'THIS FEATURE IS NOT AVAILABLE IN THE GUEST VIEW',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Text
                    Lottie.asset('assets/animationVacation.json', height: 300, width: 300),
                    const SizedBox(height: 20),
                    Text(
                      'Please create an account and log in to the application to get all the services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );


        }
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Check if the user is the current user
    if (FirebaseAuth.instance.currentUser?.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Text(
              data['email'][0].toUpperCase(), // Display the first character of the email
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue, // You can customize the color
          ),
          title: Text(data['email']),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChatPage(receiverUserEmail: data['email']),
              ),
            );
          },
        ),
      );
    } else {
      // If the user is the current user, return an empty container
      return Container();
    }
  }

}
