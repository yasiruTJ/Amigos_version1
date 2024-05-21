import 'package:amigos_ver1/authentication/guide_authentication/guidePageDecider.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboardChat.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboardProfile.dart';
import 'package:amigos_ver1/guideProfile/guideProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuideDashboard extends StatefulWidget {
  const GuideDashboard({super.key});

  @override
  State<GuideDashboard> createState() => _GuideDashboardState();
}

final user = FirebaseAuth.instance.currentUser;

class _GuideDashboardState extends State<GuideDashboard> {

  String name= '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    name = (await getUser(user?.email ?? "Guest"))!;
    setState(() {});
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

  int _currentIndex = 0;

  final tabs = [
    const GuideDashboardProfile(),
    const GuideDashboardChat()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        elevation: 0,
        iconSize: 25,
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromRGBO(43, 52, 140, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded, color: Colors.white), label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1)),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble, color: Colors.white), label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1))
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
