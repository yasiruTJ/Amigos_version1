import 'package:amigos_ver1/dashboardMain/dashboardPage.dart';
import 'package:amigos_ver1/mapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../placeFinder/locationIdentifier.dart';
import '../userProfile/profilePage.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String name= '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  final user = FirebaseAuth.instance.currentUser!;

  void getData() async {
    name = (await getUser(user.email!))!;
    setState(() {});
  }

  //Get user details
  Future<String?> getUser(String email) async {
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

  int _currentIndex = 0;

  final tabs = [
    const DashboardPage(),
    const LocationIdentifier(),
    const MapPage(),
    const Text("Planner")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Hello, $name",
          style: const TextStyle(
            color: Color.fromRGBO(24, 22, 106, 1)
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                CupertinoPageRoute(builder: (context)=> Profile()));
              },
              icon: const Icon(Icons.person,color: Color.fromRGBO(24, 22, 106, 1)),
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        elevation: 0,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.place_rounded, color: Colors.white), label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1)),
          BottomNavigationBarItem(icon: Icon(Icons.enhance_photo_translate, color: Colors.white), label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1)),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded, color: Colors.white),label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1)),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket_rounded, color: Colors.white),label: '',backgroundColor: const Color.fromRGBO(43, 52, 140, 1))
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
