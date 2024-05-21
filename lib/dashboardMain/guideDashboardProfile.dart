import 'package:amigos_ver1/dashboardMain/guideMainProfile.dart';
import 'package:amigos_ver1/dashboardMain/noGuideData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GuideDashboardProfile extends StatefulWidget {
  const GuideDashboardProfile({super.key});

  @override
  State<GuideDashboardProfile> createState() => _GuideDashboardProfileState();
}

class _GuideDashboardProfileState extends State<GuideDashboardProfile> {

  final user = FirebaseAuth.instance.currentUser;

  late Future<String> _profilePicFuture;
  String? imageUrl;
  bool imageExists = false;
  Map<String, dynamic> guideDetails = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      checkSavedGuideDetails();
    });
    _profilePicFuture = getProfilePic();
  }

  void checkSavedGuideDetails()async{
    guideDetails = await fetchGuideDetails();
    setState(() {});
  }

  Future<Map<String, dynamic>> fetchGuideDetails()async{
    final user = this.user;
    if (user != null) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        CollectionReference usersCollection = firestore.collection('guideDetails');
        String? documentId = user.email!;

        DocumentSnapshot snapshot = await usersCollection.doc(documentId).get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return data;
        } else {
          return {}; // Return an empty map if the document doesn't exist
        }
      } catch (e) {
        print('Error loading guide Details: $e');
        return {}; // Return an empty map in case of an error
      }
    }else {
      print('Guest Access');
      return {};
    }
  }

  Future<String> getProfilePic()async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('guide_profile_pictures/${user?.email}/profilePic.jpg');
    imageUrl = await ref.getDownloadURL() ;
    String url = imageUrl!;
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profilePicFuture,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              backgroundColor: Color.fromRGBO(214, 217, 244, 1),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator( // Circular progress indicator with a dashed appearance
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(24, 22, 106, 1)),
                      strokeWidth: 3.0,
                    ),
                    SizedBox(height: 15.0,),
                    Text("Loading the dashboard for you...",
                      style: TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontSize: 15.0
                      ),),
                  ],
                ),
              )
          );
        }else{
          if (guideDetails['firstName'] == null || guideDetails['lastName'] == null ||
              guideDetails["Nationality"] == null || guideDetails['Spoken Language 1'] == null
              || guideDetails['Spoken Language 2'] == null || guideDetails['Location 1'] == null
              || guideDetails['Location 2'] == null || guideDetails['Location 3'] == null
              || guideDetails['charges'] == null ){
            return const NoGuideData();
          }
          else{
            return const GuideMainProfile();
          }
          }
        }
    );
  }
}

