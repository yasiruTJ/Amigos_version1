import 'package:amigos_ver1/chat_bubble.dart';
import 'package:amigos_ver1/chat_services/chatService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  const ChatPage({super.key, required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messsageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //send message
  void sendMessage() async{
    //only send messages if there is anything to be sent
    if (_messsageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserEmail, _messsageController.text);
      //clear the text controller after sending the message
      _messsageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
        elevation: 0,
        title: Text(widget.receiverUserEmail,style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
        child: Column(
          children: [
            //messages
            Expanded(
                child: _buildMessageList(),
            ),
            //user input
            _buildMessageInput(),
            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }

  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserEmail, _firebaseAuth.currentUser!.email.toString()
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while fetching data
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
                  "Loading previous chats...",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1), fontSize: 15.0),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Display an error message if an error occurs
          print('Error${snapshot.error}');
          return Text('Error${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Display a message if there is no data
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outlined,
                  color: Color.fromRGBO(24, 22, 106, 1),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "No previous chats found",
                  style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Start a conversation now :)",
                  style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    height: 0,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Display the ListView if data is available
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document)).toList(),
          );
        }
      },
    );
  }


  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;

    //align the message to the right if sender is current user, or else to the left
    var alignment = (data['senderEmail'] == _firebaseAuth.currentUser!.email.toString())
        ?Alignment.centerRight
        :Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          data['senderEmail'] == _firebaseAuth.currentUser!.email.toString()
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment:
          data['senderEmail'] == _firebaseAuth.currentUser!.email.toString()
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }


  //build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _messsageController,
                obscureText: false,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    hintText: "Enter message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromRGBO(236, 236, 237, 1),
                    filled: true,),
              )),
          IconButton(
            onPressed: (){
              sendMessage();
            },
            color: Colors.black,
            icon: Icon(Icons.send, size: 25.0,color: Color.fromRGBO(24, 22, 106, 1),),
          )
        ],
      ),
    );
  }


}

