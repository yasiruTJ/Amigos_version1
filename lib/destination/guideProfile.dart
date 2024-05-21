import 'package:amigos_ver1/chatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelGuideProfile extends StatefulWidget {
  final String guideEmail;
  const TravelGuideProfile({super.key, required this.guideEmail});

  @override
  State<TravelGuideProfile> createState() => _TravelGuideProfileState();
}

class _TravelGuideProfileState extends State<TravelGuideProfile> {
  String? imageUrl;
  Map<String, dynamic> guideDetails = {};

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
    pageLoadingTasks();
  }

  void pageLoadingTasks()async{
    getProfilePic();
    guideDetails = await retrieveGuideDetails();

    Map<String, dynamic> mondayStartTime = guideDetails['mondayStart'] ?? {};
    Map<String, dynamic> mondayFinishTime = guideDetails['mondayFinish']?? {};
    Map<String, dynamic> tuesdayStartTime = guideDetails['tuesdayStart']?? {};
    Map<String, dynamic> tuesdayFinishTime = guideDetails['tuesdayFinish']?? {};
    Map<String, dynamic> wednesdayStartTime = guideDetails['wednesdayStart']?? {};
    Map<String, dynamic> wednesdayFinishTime = guideDetails['wednesdayFinish']?? {};
    Map<String, dynamic> thursdayStartTime = guideDetails['thursdayStart']?? {};
    Map<String, dynamic> thursdayFinishTime = guideDetails['thursdayFinish']?? {};
    Map<String, dynamic> fridayStartTime = guideDetails['fridayStart']?? {};
    Map<String, dynamic> fridayFinishTime = guideDetails['fridayFinish']?? {};
    Map<String, dynamic> saturdayStartTime = guideDetails['saturdayStart']?? {};
    Map<String, dynamic> saturdayFinishTime = guideDetails['saturdayFinish']?? {};
    Map<String, dynamic> sundayStartTime = guideDetails['sundayStart']?? {};
    Map<String, dynamic> sundayFinishTime = guideDetails['sundayFinish']?? {};
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
      mondayStart = TimeOfDay(hour: int.tryParse(mondayStartTime["hour"] ?? "") ?? 0, minute: int.tryParse(mondayStartTime["minute"]?? "")?? 0);
      mondayFinish = TimeOfDay(hour: int.tryParse(mondayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(mondayFinishTime["minute"]?? "")?? 0);
      tuesdayStart = TimeOfDay(hour: int.tryParse(tuesdayStartTime["hour"]?? "")?? 0, minute: int.tryParse(tuesdayStartTime["minute"]?? "")?? 0);
      tuesdayFinish = TimeOfDay(hour: int.tryParse(tuesdayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(tuesdayFinishTime["minute"]?? "")?? 0);
      wednesdayStart = TimeOfDay(hour: int.tryParse(wednesdayStartTime["hour"]?? "")?? 0, minute: int.tryParse(wednesdayStartTime["minute"]?? "")?? 0);
      wednesdayFinish = TimeOfDay(hour: int.tryParse(wednesdayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(wednesdayFinishTime["minute"]?? "")?? 0);
      thursdayStart = TimeOfDay(hour: int.tryParse(thursdayStartTime["hour"]?? "")?? 0, minute: int.tryParse(thursdayStartTime["minute"]?? "")?? 0);
      thursdayFinish = TimeOfDay(hour: int.tryParse(thursdayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(thursdayFinishTime["minute"]?? "")?? 0);
      fridayStart = TimeOfDay(hour: int.tryParse(fridayStartTime["hour"]?? "")?? 0, minute: int.tryParse(fridayStartTime["minute"]?? "")?? 0);
      fridayFinish = TimeOfDay(hour: int.tryParse(fridayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(fridayFinishTime["minute"]?? "")?? 0);
      saturdayStart = TimeOfDay(hour: int.tryParse(saturdayStartTime["hour"]?? "")?? 0, minute: int.tryParse(saturdayStartTime["minute"]?? "")?? 0);
      saturdayFinish = TimeOfDay(hour: int.tryParse(saturdayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(saturdayFinishTime["minute"]?? "")?? 0);
      sundayStart = TimeOfDay(hour: int.tryParse(sundayStartTime["hour"]?? "")?? 0, minute: int.tryParse(sundayStartTime["minute"]?? "")?? 0);
      sundayFinish = TimeOfDay(hour: int.tryParse(sundayFinishTime["hour"]?? "")?? 0, minute: int.tryParse(sundayFinishTime["minute"]?? "")?? 0);
    });
  }

  Future<String?> getProfilePic()async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('guide_profile_pictures/${widget.guideEmail}/profilePic.jpg');
    imageUrl = await ref.getDownloadURL();
    String? url = imageUrl ?? "";
    print(url);
    return url;
  }

  Future<Map<String, dynamic>> retrieveGuideDetails()async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersCollection = firestore.collection('guideDetails');

      DocumentSnapshot snapshot = await usersCollection.doc(widget.guideEmail).get();

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([getProfilePic(), retrieveGuideDetails()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
            body: Center(
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
                    "Fetching location details...",
                    style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1), fontSize: 15.0),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Extracting results from the snapshot
          String? imageUrl = snapshot.data![0] as String?;
          Map<String, dynamic> guideDetails = snapshot.data![1] as Map<String, dynamic>;

          // Once both futures complete successfully, build the UI with the data
          return Scaffold(
            backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
              elevation: 0,
              title: const Text("GET IN TOUCH WITH YOUR GUIDE",style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0
              )),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60.0,20.0,60.0,50.0),
                child: Center(
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundColor: Colors.white,
                          backgroundImage: imageUrl != ""
                              ? NetworkImage(imageUrl!)
                              : const NetworkImage(
                              "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${guideDetails.length > 1 ? guideDetails['firstName'] : ''} ${guideDetails.isNotEmpty ? guideDetails['lastName'] : ''}',
                        style: const TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10.0,),
                      Text(widget.guideEmail,
                        style: const TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 30.0,),
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
                              Text(guideDetails['Nationality'],
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
                              Text(guideDetails['Spoken Language 1'],
                                style: const TextStyle(
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontSize: 12.0
                                ),),
                              const SizedBox(height: 10.0,),
                              Text(guideDetails['Spoken Language 2'],
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
                              Text(guideDetails['Location 1'],
                                style: const TextStyle(
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontSize: 12.0
                                ),),
                              SizedBox(height: 10.0,),
                              Text(guideDetails['Location 2'],
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontSize: 12.0
                                ),),
                              SizedBox(height: 10.0,),
                              Text(guideDetails['Location 3'],
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
                              Text("${guideDetails['charges']} £",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontSize: 12.0
                                ),),
                            ],
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          onPressed: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>ChatPage(receiverUserEmail: guideDetails['email'])));
                          },
                          backgroundColor: Color.fromRGBO(214, 217, 244, 1),
                          child: Icon(
                            Icons.chat_bubble,
                            color: Color.fromRGBO(24, 22, 106, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
