import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../chatPage.dart';

class UserChats extends StatefulWidget {
  const UserChats({super.key});

  @override
  State<UserChats> createState() => _UserChatsState();
}

class _UserChatsState extends State<UserChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 217, 244, 1),
      body: _buildGuideChatList(),
    );
  }

  Widget _buildGuideChatList(){
    return StreamBuilder<QuerySnapshot>
      (stream: FirebaseFirestore.instance.collection('guides').snapshots(),
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

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc)=> _buildGuideListItem(doc))
                .toList(),
          );
        }
    );
  }

  Widget _buildGuideListItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('email')) {
      // Check if 'email' key exists in data
      String userEmail = data['email'];

      // Check if the user is the current user
      if (FirebaseAuth.instance.currentUser!.email != userEmail) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(
                userEmail[0].toUpperCase(), // Display the first character of the email
                style: TextStyle(color: Colors.white),
              ), // You can customize the color
            ),
            title: Text(userEmail),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChatPage(receiverUserEmail: userEmail),
                ),
              );
            },
          ),
        );
      }
    }

    // If data is null or email is not present, return an empty container
    return Container();
  }


}
