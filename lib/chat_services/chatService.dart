import 'package:amigos_ver1/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{

  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND messages functionality
  Future<void> sendMessage(String receiverEmail, String message) async{
    //get current user info
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp
    );

    //construct chat room for the receiver id and current user id
    List<String> ids = [currentUserEmail,receiverEmail];
    ids.sort();//this is done to ensure that the chat room id is same for any pair
    String chatroomId = ids.join("_");//combining the userIds to make a single chatroom ID

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GET messages functionality
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages (String userEmail, String otherUserEmail){
    //construct chat rooms from user ids
    List<String> ids = [userEmail,otherUserEmail];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore.collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .snapshots();
  }

}