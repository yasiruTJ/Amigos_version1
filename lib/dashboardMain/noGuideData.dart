import 'dart:io';

import 'package:amigos_ver1/dashboardMain/guideAvailability.dart';
import 'package:amigos_ver1/dashboardMain/guideDashboardProfile.dart';
import 'package:amigos_ver1/guideProfile/guideProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../authentication/guide_authentication/guideAuthPage.dart';


class NoGuideData extends StatefulWidget {
  const NoGuideData({super.key});

  @override
  State<NoGuideData> createState() => _NoGuideDataState();
}

class _NoGuideDataState extends State<NoGuideData> {
  final user = FirebaseAuth.instance.currentUser;
  late Future<String> _profilePicFuture;
  File? _imageFile;
  String? imageUrl;
  String name= '';
  bool imageExists = false;
  bool _showAvailabilityText = false;
  //Dropdown selectors
  String? _selectedNationalityOption;
  String? _selectedSpokenLanguage1Option;
  String? _selectedSpokenLanguage2Option;
  String? _selectedLocation1Option;
  String? _selectedLocation2Option;
  String? _selectedLocation3Option;
  //text field
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController charges = TextEditingController();
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
  void initState(){
    super.initState();
    getData();
    _profilePicFuture = getProfilePic();
    checkImageExistence().then((exists) {
      setState(() {
        imageExists = exists;
      });
    });
}
  void getData() async {
    name = (await getUser(user?.email ?? "Guest User"))!;
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

  Future<Map<String, dynamic>> retrieveGuideDetails()async{
    final user = this.user;
    if (user != null) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        CollectionReference usersCollection = firestore.collection(
            'guideDetails');
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
    }else {
      print('Guest Access');
      return {};
    }
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

  void updateGuideProfileDetails()async{
    print(imageUrl);
    if (firstName.text.trim() != "" && lastName.text.trim() != "" && _selectedNationalityOption != null && _selectedSpokenLanguage1Option != null && _selectedSpokenLanguage2Option != null && _selectedLocation1Option != null && _selectedLocation2Option != null && _selectedLocation3Option != null && charges.text.trim() != "" && imageUrl != null){
      return showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white.withOpacity(0.9),
          builder: (context) {
            return AlertDialog(
              title: const Text("Update Details?"),
              content: const Text(
                "The information provided will be displayed to the users. Later you will be able to change and update these information as you see fit. Are you sure you want to proceed?",textAlign: TextAlign.justify,style: TextStyle(
                  height: 1.5
              ),),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      try{
                        CollectionReference users = FirebaseFirestore.instance.collection('guideDetails');
                        await users.doc(user?.email).update({
                          'email': user?.email ?? "",
                          'firstName':firstName.text.trim()?? "",
                          'lastName':lastName.text.trim()?? "",
                          'Nationality': _selectedNationalityOption,
                          'Spoken Language 1': _selectedSpokenLanguage1Option ?? "",
                          'Spoken Language 2' : _selectedSpokenLanguage2Option ?? "",
                          'Location 1' : _selectedLocation1Option?? "",
                          'Location 2' : _selectedLocation2Option?? "",
                          'Location 3' : _selectedLocation3Option?? "",
                          'charges' :   charges.text.trim()?? ""
                        });
                        Navigator.pop(context);
                        Navigator.push(context,CupertinoPageRoute(builder: (context)=>GuideDashboardProfile()));
                        print('success') ;
                      }catch (e){
                        print('Error adding user') ;
                      }
                    },
                    child: const Text("Update"))
              ],
            );
          });
    }
    else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Execution failed"),
              content: const Text("All the text fields should be filled to proceed. Please note that it is mandatory for tour guides to add  a profile picture.",textAlign: TextAlign.justify,style: TextStyle(
                  height: 1.5
              ),),
              actions: [
                MaterialButton(
                  onPressed: () {Navigator.pop(context);},
                  child: Text("OK"),
                ),
              ],
            );
          });
    }
  }

  //upload photo
  Future<void> uploadPhoto() async {

    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("No Image Detected!"),
            content: const Text(
              "Image cannot be identified. Please make sure that you have uploaded an image!",textAlign: TextAlign.justify,style: TextStyle(
                height: 1.5
            ),),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Exit the method if no image is selected
    }

    final imageTemp = File(imageFile.path);

    setState(() {
      _imageFile = imageTemp;
    });

    if (_imageFile != null){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Changes?"),
            content: const Text("You will be redirected to the main page for the changes to be applied.",textAlign: TextAlign.justify,style: TextStyle(
                height: 1.5
            ),),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              MaterialButton(
                onPressed: () async{
                  Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('guide_profile_pictures/${user?.email}/profilePic.jpg');
                  firebaseStorageRef.putFile(_imageFile!, SettableMetadata(contentType: 'image/jpeg'));
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<String> getProfilePic()async{
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('guide_profile_pictures/${user?.email}/profilePic.jpg');
    imageUrl = await ref.getDownloadURL() ?? "";
    String url = imageUrl!;
    return url;
  }

  Future<bool> checkImageExistence() async {
    try {
      Reference ref = FirebaseStorage.instance.ref('guide_profile_pictures/${user?.email}/profilePic.jpg');
      await ref.getDownloadURL();
      return true; // Image exists
    } catch (e) {
      return false; // Image does not exist
    }
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
                      Text("Loading the dashboard details...",
                        style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontSize: 15.0
                        ),),
                    ],
                  ),
                )
            );
          }else {
            return Scaffold(
              backgroundColor: Color.fromRGBO(214, 217, 244, 1),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Color.fromRGBO(24, 22, 106, 1),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                  radius: 70.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageExists &&
                                      imageUrl != null
                                      ? NetworkImage(
                                      imageUrl!) // Use _imageFile if it's not null
                                      : const NetworkImage(
                                      "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png")
                              ),
                              Positioned(
                                bottom: 0,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    uploadPhoto();
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            100.0),
                                        color: Color.fromRGBO(175, 173, 248, 1)
                                    ),
                                    child: const Icon(
                                      Icons.edit, color: const Color.fromRGBO(
                                        24, 22, 106, 1),
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Available dates and times',
                              style: TextStyle(
                                color: Color.fromRGBO(24, 22, 106, 1),
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            IconButton(onPressed: () {
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=> const GuideAvaialbility()));
                            },
                                icon: Icon(Icons.edit,
                              size: 20, color: Color.fromRGBO(24, 22, 106, 1),))
                          ],
                        ),
                        SizedBox(height: 10,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _mondayAvailability == "Available"
                                      ? const Color.fromRGBO(175, 173, 248, 1)
                                      : Colors.white,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("MON"),
                                ),
                              ),

                              SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _tuesdayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("TUE")),
                              ),
                              SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _wednesdayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("WED")),
                              ),
                              SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _thursdayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("THU")),
                              ),
                              SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _fridayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("FRI")),
                              ),
                              const SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _saturdayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("SAT")),
                              ),
                              SizedBox(width: 20.0,),
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _sundayAvailability == "Available"? const Color.fromRGBO(175, 173, 248, 1) : Colors.white,
                                ),
                                child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("SUN")),
                              ),
                              SizedBox(width: 20.0,),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Container(
                          height: 930,
                          width: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color.fromRGBO(175, 173, 248, 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Tour Guide Details",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Roboto'
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "First name",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: firstName,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  cursorColor: const Color.fromRGBO(
                                      141, 116, 116, 1),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                ),
                                SizedBox(height: 10.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Last name",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: lastName,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  cursorColor: const Color.fromRGBO(
                                      141, 116, 116, 1),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                ),
                                SizedBox(height: 10.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nationality",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedNationalityOption,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedNationalityOption = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'British',
                                    'French',
                                    'Italian',
                                    'Spanish',
                                    'German',
                                    'Asian'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Spoken languages",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedSpokenLanguage1Option,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSpokenLanguage1Option = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'English',
                                    'Spanish',
                                    'French',
                                    'German',
                                    'Mandarin Chinese',
                                    'Italian',
                                    'Japanese',
                                    'Arabic'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedSpokenLanguage2Option,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSpokenLanguage2Option = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'English',
                                    'Spanish',
                                    'French',
                                    'German',
                                    'Mandarin Chinese',
                                    'Italian',
                                    'Japanese',
                                    'Arabic'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Location",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedLocation1Option,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLocation1Option = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'The British Museum',
                                    'Tower of London',
                                    'Buckingham Palace',
                                    'Westminster Abbey',
                                    'Big Ben',
                                    'The London Eye',
                                    'Stonehenge',
                                    'The Tower Bridge',
                                    'The Churchill War Rooms',
                                    'Edinburgh Castle',
                                    'Windsor Castle',
                                    'Roman Baths',
                                    "Hadrian's Wall",
                                    'Blenheim Palace',
                                    'The Cotswolds',
                                    'The Lake District National Park',
                                    'The Scottish Highlands',
                                    'The Peak District National Park',
                                    'The Eden Project'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedLocation2Option,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLocation2Option = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'The British Museum',
                                    'Tower of London',
                                    'Buckingham Palace',
                                    'Westminster Abbey',
                                    'Big Ben',
                                    'The London Eye',
                                    'Stonehenge',
                                    'The Tower Bridge',
                                    'The Churchill War Rooms',
                                    'Edinburgh Castle',
                                    'Windsor Castle',
                                    'Roman Baths',
                                    "Hadrian's Wall",
                                    'Blenheim Palace',
                                    'The Cotswolds',
                                    'The Lake District National Park',
                                    'The Scottish Highlands',
                                    'The Peak District National Park',
                                    'The Eden Project'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DropdownButtonFormField<String>(
                                  value: _selectedLocation3Option,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLocation3Option = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'N/A',
                                    'The British Museum',
                                    'Tower of London',
                                    'Buckingham Palace',
                                    'Westminster Abbey',
                                    'Big Ben',
                                    'The London Eye',
                                    'Stonehenge',
                                    'The Tower Bridge',
                                    'The Churchill War Rooms',
                                    'Edinburgh Castle',
                                    'Windsor Castle',
                                    'Roman Baths',
                                    "Hadrian's Wall",
                                    'Blenheim Palace',
                                    'The Cotswolds',
                                    'The Lake District National Park',
                                    'The Scottish Highlands',
                                    'The Peak District National Park',
                                    'The Eden Project'
                                  ]
                                      .map<DropdownMenuItem<String>>((
                                      String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20.0,),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Charges per hour (£)",
                                    style: TextStyle(
                                        color: Color.fromRGBO(45, 87, 124, 1),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                TextFormField(
                                  controller: charges,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0),
                                        borderSide: BorderSide.none
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  cursorColor: const Color.fromRGBO(
                                      141, 116, 116, 1),
                                  autocorrect: true,
                                  enableSuggestions: true,
                                ),
                                SizedBox(height: 35.0,),
                                ElevatedButton(
                                  onPressed: () {
                                    updateGuideProfileDetails();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          24, 22, 106, 1),
                                      padding: const EdgeInsets.fromLTRB(
                                          100.0, 10.0, 100.0, 10.0),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            25.0),
                                      )
                                  ), child: const Text(
                                  "Create Profile",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            );
          }
        }
    );
  }
}

