import 'package:amigos_ver1/dashboardMain/noGuideData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../guideProfile/guideProfile.dart';

class GuideMainProfile extends StatefulWidget {
  const GuideMainProfile({super.key});

  @override
  State<GuideMainProfile> createState() => _GuideMainProfileState();
}

class _GuideMainProfileState extends State<GuideMainProfile> {
  bool imageExists = false;
  String? imageUrl;
  String name = '';
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> guideDetails = {};
  late Future<List<dynamic>> _loadingFuture;

  //Dropdown selectors
  String? _mondayAvailability;
  String? _tuesdayAvailability;
  String? _wednesdayAvailability;
  String? _thursdayAvailability;
  String? _fridayAvailability;
  String? _saturdayAvailability;
  String? _sundayAvailability;

  //Timedisplays
  TimeOfDay? mondayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? mondayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? tuesdayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? tuesdayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? wednesdayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? wednesdayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? thursdayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? thursdayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? fridayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? fridayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? saturdayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? saturdayFinish = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? sundayStart = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? sundayFinish = const TimeOfDay(hour: 00, minute: 00);


  @override
  void initState() {
    super.initState();
    getData();
    _loadingFuture = Future.wait([
      retrieveGuideName(),
      retrieveGuideDetails(),
      getProfilePic(),
    ]);
    _loadingFuture.then((_) {
      setState(() {});
      dashboardLoadingTasks();
    });
  }

  void getData() async {
    name = (await getUser(user.email!))!;
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
      return 'Error fetching user';
    }
  }


  void dashboardLoadingTasks() async {
    guideDetails = await retrieveGuideDetails();

    Map<String, dynamic> mondayStartTime = guideDetails['mondayStart'];
    Map<String, dynamic> mondayFinishTime = guideDetails['mondayFinish'];
    Map<String, dynamic> tuesdayStartTime = guideDetails['tuesdayStart'];
    Map<String, dynamic> tuesdayFinishTime = guideDetails['tuesdayFinish'];
    Map<String, dynamic> wednesdayStartTime = guideDetails['wednesdayStart'];
    Map<String, dynamic> wednesdayFinishTime = guideDetails['wednesdayFinish'];
    Map<String, dynamic> thursdayStartTime = guideDetails['thursdayStart'];
    Map<String, dynamic> thursdayFinishTime = guideDetails['thursdayFinish'];
    Map<String, dynamic> fridayStartTime = guideDetails['fridayStart'];
    Map<String, dynamic> fridayFinishTime = guideDetails['fridayFinish'];
    Map<String, dynamic> saturdayStartTime = guideDetails['saturdayStart'];
    Map<String, dynamic> saturdayFinishTime = guideDetails['saturdayFinish'];
    Map<String, dynamic> sundayStartTime = guideDetails['sundayStart'];
    Map<String, dynamic> sundayFinishTime = guideDetails['sundayFinish'];
    //updating existing time variables
    setState(() {
      _mondayAvailability = guideDetails['mondayAvailability'];
      _tuesdayAvailability = guideDetails['tuesdayAvailability'];
      _wednesdayAvailability = guideDetails['wednesdayAvailability'];
      _thursdayAvailability = guideDetails['thursdayAvailability'];
      _fridayAvailability = guideDetails['fridayAvailability'];
      _saturdayAvailability = guideDetails['saturdayAvailability'];
      _sundayAvailability = guideDetails['sundayAvailability'];

      //updating available times
      mondayStart = TimeOfDay(hour: int.parse(mondayStartTime["hour"]), minute: int.parse(mondayStartTime["minute"]));
      mondayFinish = TimeOfDay(hour: int.parse(mondayFinishTime["hour"]), minute: int.parse(mondayFinishTime["minute"]));
      tuesdayStart = TimeOfDay(hour: int.parse(tuesdayStartTime["hour"]), minute: int.parse(tuesdayStartTime["minute"]));
      tuesdayFinish = TimeOfDay(hour: int.parse(tuesdayFinishTime["hour"]), minute: int.parse(tuesdayFinishTime["minute"]));
      wednesdayStart = TimeOfDay(hour: int.parse(wednesdayStartTime["hour"]), minute: int.parse(wednesdayStartTime["minute"]));
      wednesdayFinish = TimeOfDay(hour: int.parse(wednesdayFinishTime["hour"]), minute: int.parse(wednesdayFinishTime["minute"]));
      thursdayStart = TimeOfDay(hour: int.parse(thursdayStartTime["hour"]), minute: int.parse(thursdayStartTime["minute"]));
      thursdayFinish = TimeOfDay(hour: int.parse(thursdayFinishTime["hour"]), minute: int.parse(thursdayFinishTime["minute"]));
      fridayStart = TimeOfDay(hour: int.parse(fridayStartTime["hour"]), minute: int.parse(fridayStartTime["minute"]));
      fridayFinish = TimeOfDay(hour: int.parse(fridayFinishTime["hour"]), minute: int.parse(fridayFinishTime["minute"]));
      saturdayStart = TimeOfDay(hour: int.parse(saturdayStartTime["hour"]), minute: int.parse(saturdayStartTime["minute"]));
      saturdayFinish = TimeOfDay(hour: int.parse(saturdayFinishTime["hour"]), minute: int.parse(saturdayFinishTime["minute"]));
      sundayStart = TimeOfDay(hour: int.parse(sundayStartTime["hour"]), minute: int.parse(sundayStartTime["minute"]));
      sundayFinish = TimeOfDay(hour: int.parse(sundayFinishTime["hour"]), minute: int.parse(sundayFinishTime["minute"]));
    });
  }

  Future<String?> getProfilePic()async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('guide_profile_pictures/${user.email}/profilePic.jpg');
    imageUrl = await ref.getDownloadURL();
    String? url = imageUrl ?? "";
    return url;
  }

  Future<Map<String, dynamic>> retrieveGuideName() async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersCollection = firestore.collection('guides');
      String? documentId = user.email;

      DocumentSnapshot snapshot = await usersCollection.doc(documentId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    } catch (e) {
      print('Error loading favourites: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  Future<Map<String, dynamic>> retrieveGuideDetails()async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersCollection = firestore.collection('guideDetails');
      String? documentId = user.email;

      DocumentSnapshot snapshot = await usersCollection.doc(documentId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    } catch (e) {
      print('Error loading guide data: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  Future<bool> checkImageExistence() async {
    try {
      Reference ref = FirebaseStorage.instance.ref('guide_profile_pictures/${user.email}/profilePic.jpg');
      await ref.getDownloadURL();
      return true; // Image exists
    } catch (e) {
      return false; // Image does not exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
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
                  "Fetching guide details...",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1), fontSize: 15.0),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Display an error message if an error occurred
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Extract guideNames and guideDetails from the snapshot data
          Map<String, dynamic> guideDetails = snapshot.data![1];

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
                IconButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context)=> GuideProfile()));
                  },
                  icon: const Icon(Icons.person,color: Color.fromRGBO(24, 22, 106, 1)),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const NoGuideData()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            )
                        ), child: Container(
                        width: 69,
                          child: const Row(
                            children: [
                              Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color.fromRGBO(104, 100, 247, 1),
                                      fontWeight: FontWeight.w500
                                  ),
                      ),
                              SizedBox(width: 10.0,),
                              Icon(Icons.edit,color: Color.fromRGBO(104, 100, 247, 1),)
                            ],
                          ),
                        ),
                        ),
                      ),
                    Center(
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundColor: Colors.white,
                        backgroundImage: imageExists || imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : const NetworkImage(
                            "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${guideDetails.length > 1 ? guideDetails['firstName'] ?? "Unknown" : ''} ${guideDetails.isNotEmpty ? guideDetails['lastName'] ?? "Unknown" : ''}',
                      style: const TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.email!,
                      style: const TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.0,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80.0,0.0,20.0,0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                radius: 30,
                                child: Icon(Icons.person_outline_sharp,color: Color.fromRGBO(104, 100, 247, 1)),
                              ),
                              SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Nationality",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 10.0,),
                                  Text(guideDetails['Nationality'] ?? "Unknown",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 25.0,),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                radius: 30,
                                child: Icon(Icons.language_sharp,color: Color.fromRGBO(104, 100, 247, 1)),
                              ),
                              SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Languages spoken",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 15.0,),
                                  Text(guideDetails['Spoken Language 1'] ?? "Unknown",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  const SizedBox(height: 10.0,),
                                  Text(guideDetails['Spoken Language 2'] ?? "Unknown",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),)
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 25.0,),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                radius: 30,
                                child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                              ),
                              const SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Services offered at",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 15.0,),
                                  Text(guideDetails['Location 1']?? "Unknown",
                                    style: const TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10.0,),
                                  Text(guideDetails['Location 2']?? "Unknown",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10.0,),
                                  Text(guideDetails['Location 3']?? "Unknown",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 25.0,),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                radius: 30,
                                child: Icon(Icons.timer_sharp,color: Color.fromRGBO(104, 100, 247, 1)),
                              ),
                              SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Available times",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 10.0,),
                                  Text(_mondayAvailability == "Available" ? "Monday : (${mondayStart!.hour.toString().padLeft(2, '0')} : ${mondayStart!.minute.toString().padLeft(2, '0')} - ${mondayFinish!.hour.toString().padLeft(2, '0')} : ${mondayFinish!.minute.toString().padLeft(2, '0')})":"Monday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_tuesdayAvailability == "Available" ? "Tuesday : (${tuesdayStart!.hour.toString().padLeft(2, '0')} : ${tuesdayStart!.minute.toString().padLeft(2, '0')} - ${tuesdayFinish!.hour.toString().padLeft(2, '0')} : ${tuesdayFinish!.minute.toString().padLeft(2, '0')})":"Tuesday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_wednesdayAvailability == "Available" ? "Wednesday : (${wednesdayStart!.hour.toString().padLeft(2, '0')} : ${wednesdayStart!.minute.toString().padLeft(2, '0')} - ${wednesdayFinish!.hour.toString().padLeft(2, '0')} : ${wednesdayFinish!.minute.toString().padLeft(2, '0')})":"Wednesday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_thursdayAvailability == "Available" ? "Thursday : (${thursdayStart!.hour.toString().padLeft(2, '0')} : ${thursdayStart!.minute.toString().padLeft(2, '0')} - ${thursdayFinish!.hour.toString().padLeft(2, '0')} : ${thursdayFinish!.minute.toString().padLeft(2, '0')})":"Thursday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_fridayAvailability == "Available" ? "Friday : (${fridayStart!.hour.toString().padLeft(2, '0')} : ${fridayStart!.minute.toString().padLeft(2, '0')} - ${fridayFinish!.hour.toString().padLeft(2, '0')} : ${fridayFinish!.minute.toString().padLeft(2, '0')})":"Friday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_saturdayAvailability == "Available" ? "Saturday : (${saturdayStart!.hour.toString().padLeft(2, '0')} : ${saturdayStart!.minute.toString().padLeft(2, '0')} - ${saturdayFinish!.hour.toString().padLeft(2, '0')} : ${saturdayFinish!.minute.toString().padLeft(2, '0')})":"Saturday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                  SizedBox(height: 10,),
                                  Text(_sundayAvailability == "Available" ? "Sunday : (${sundayStart!.hour.toString().padLeft(2, '0')} : ${sundayStart!.minute.toString().padLeft(2, '0')} - ${sundayFinish!.hour.toString().padLeft(2, '0')} : ${sundayFinish!.minute.toString().padLeft(2, '0')})":"Sunday : Not Available",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 25.0,),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                radius: 30,
                                child: Icon(Icons.price_change_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                              ),
                              SizedBox(width: 20.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Chrages per hour (£)",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontWeight: FontWeight.bold
                                    ),),
                                  SizedBox(height: 10.0,),
                                  Text("${guideDetails['charges']?? "Unknown"} £",
                                    style: TextStyle(
                                        color: Color.fromRGBO(24, 22, 106, 1),
                                        fontSize: 12.0
                                    ),)
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

}
