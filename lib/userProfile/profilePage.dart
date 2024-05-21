import 'dart:ui';
import 'package:amigos_ver1/authentication/traveller_authentication/pageDecider.dart';
import 'package:amigos_ver1/userProfile/userOptions/userChatsProfile.dart';
import 'package:amigos_ver1/userProfile/userOptions/userPhotoGallery.dart';
import 'package:amigos_ver1/userProfile/userOptions/userProfileView.dart';
import 'package:amigos_ver1/userProfile/userOptions/userSettingsSelectionPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../authentication/traveller_authentication/userDeleteAccountPage.dart';
import 'userOptions/editProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            indicatorColor: Color.fromRGBO(24, 22, 106, 1),
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
                child: Icon(Icons.chat,color: Color.fromRGBO(104, 100, 247, 1)),
              ),
              ),
              Tab(child: CircleAvatar(
                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                radius: 100,
                child: Icon(Icons.photo,color: Color.fromRGBO(104, 100, 247, 1)),
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
        body: const TabBarView(children: [
          UserProfileDetailsGuide(),
          UserChats(),
          UserPhotoGallery(),
          UserSettings()
        ]),
      ),
    );
  }
}
