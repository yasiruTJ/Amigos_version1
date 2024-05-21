import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GuideAvaialbility extends StatefulWidget {
  const GuideAvaialbility({super.key});

  @override
  State<GuideAvaialbility> createState() => _GuideAvaialbilityState();
}

class _GuideAvaialbilityState extends State<GuideAvaialbility> {
  final user = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic> guideAvailability = {};

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
  initState(){
    super.initState();
    availabilityLoadingTasks();
  }

  void availabilityLoadingTasks() async{
    guideAvailability = await getAvailabilityDatabase();
    Map<String, dynamic> mondayStartTime = guideAvailability['mondayStart'];
    Map<String, dynamic> mondayFinishTime = guideAvailability['mondayFinish'];
    Map<String, dynamic> tuesdayStartTime = guideAvailability['tuesdayStart'];
    Map<String, dynamic> tuesdayFinishTime = guideAvailability['tuesdayFinish'];
    Map<String, dynamic> wednesdayStartTime = guideAvailability['wednesdayStart'];
    Map<String, dynamic> wednesdayFinishTime = guideAvailability['wednesdayFinish'];
    Map<String, dynamic> thursdayStartTime = guideAvailability['thursdayStart'];
    Map<String, dynamic> thursdayFinishTime = guideAvailability['thursdayFinish'];
    Map<String, dynamic> fridayStartTime = guideAvailability['fridayStart'];
    Map<String, dynamic> fridayFinishTime = guideAvailability['fridayFinish'];
    Map<String, dynamic> saturdayStartTime = guideAvailability['saturdayStart'];
    Map<String, dynamic> saturdayFinishTime = guideAvailability['saturdayFinish'];
    Map<String, dynamic> sundayStartTime = guideAvailability['sundayStart'];
    Map<String, dynamic> sundayFinishTime = guideAvailability['sundayFinish'];

    print(mondayStartTime['hour']);
    setState(() {
      //availability in a week
      _mondayAvailability = guideAvailability['mondayAvailability'];
      _tuesdayAvailability = guideAvailability['tuesdayAvailability'];
      _wednesdayAvailability = guideAvailability['wednesdayAvailability'];
      _thursdayAvailability = guideAvailability['thursdayAvailability'];
      _fridayAvailability = guideAvailability['fridayAvailability'];
      _saturdayAvailability = guideAvailability['saturdayAvailability'];
      _sundayAvailability = guideAvailability['sundayAvailability'];
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

  Future<Map<String, dynamic>> getAvailabilityDatabase()async{
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
      print('Error loading guide availability: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  void updateAvailability() async{
    if(_mondayAvailability != null && _tuesdayAvailability != null && _wednesdayAvailability != null && _thursdayAvailability != null && _fridayAvailability != null && _saturdayAvailability != null && _sundayAvailability != null){
      return showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white.withOpacity(0.9),
          builder: (context) {
            return AlertDialog(
              title: const Text("Update Availability?"),
              content: const Text(
                "The information provided will be displayed to the users. Later you will be able to change and update your availability. Are you sure you want to proceed?",textAlign: TextAlign.justify,style: TextStyle(
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
                        await users.doc(user.email).update({
                          'mondayAvailability' : _mondayAvailability,
                          'tuesdayAvailability' : _tuesdayAvailability,
                          'wednesdayAvailability' : _wednesdayAvailability,
                          'thursdayAvailability' : _thursdayAvailability,
                          'fridayAvailability' : _fridayAvailability,
                          'saturdayAvailability' : _saturdayAvailability,
                          'sundayAvailability' : _sundayAvailability,
                          //saving times
                          'mondayStart' : _timeOfDayToMap(mondayStart),
                          'mondayFinish' :_timeOfDayToMap(mondayFinish),
                          'tuesdayStart' :_timeOfDayToMap(tuesdayStart),
                          'tuesdayFinish' :_timeOfDayToMap(tuesdayFinish),
                          'wednesdayStart' :_timeOfDayToMap(wednesdayStart),
                          'wednesdayFinish' :_timeOfDayToMap(wednesdayFinish),
                          'thursdayStart' :_timeOfDayToMap(thursdayStart),
                          'thursdayFinish' :_timeOfDayToMap(thursdayFinish),
                          'fridayStart' :_timeOfDayToMap(fridayStart),
                          'fridayFinish' :_timeOfDayToMap(fridayFinish),
                          'saturdayStart' :_timeOfDayToMap(saturdayStart),
                          'saturdayFinish' :_timeOfDayToMap(saturdayFinish),
                          'sundayStart' :_timeOfDayToMap(sundayStart),
                          'sundayFinish' :_timeOfDayToMap(sundayFinish)
                        });
                        Navigator.pop(context);
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
              content: const Text("Please fill your availability for all the days in the week.",textAlign: TextAlign.justify,style: TextStyle(
                  height: 1.5
              ),),
              actions: [
                MaterialButton(
                  onPressed: () {Navigator.pop(context);},
                  child: const Text("OK"),
                ),
              ],
            );
          });
    }
  }

  // Helper function to convert TimeOfDay to Map
  Map<String, dynamic>? _timeOfDayToMap(TimeOfDay? time) {
    if (time != null) {
      return {'hour': time.hour.toString().padLeft(2,'0'), 'minute': time.minute.toString().padLeft(2,'0')};
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
        elevation: 0,
        title: const Text("TOUR GUIDE AVAILABILITY",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.0,30.0,25.0,50.0),
          child: Column(
            children: [
              const Text("* Please note that the availability should be updated for every week. Updated availability will be displayed to the travellers. "),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("MONDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15.0
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _mondayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _mondayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _mondayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: ()async{
                            TimeOfDay? newTime = await showTimePicker(
                                context: context, initialTime: mondayStart!);
                            if (newTime != null){
                              setState(() {
                                mondayStart = newTime;
                              });
                            }
                          },
                          child: Text("${mondayStart!.hour.toString().padLeft(2, '0')} : ${mondayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                      Text("---"),
                      GestureDetector(
                          onTap: ()async{
                            TimeOfDay? newTime = await showTimePicker(
                                context: context, initialTime: mondayFinish!);
                            if (newTime != null){
                              setState(() {
                                mondayFinish = newTime;
                              });
                            }
                          },
                          child: Text("${mondayFinish!.hour.toString().padLeft(2, '0')} : ${mondayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                    ],
                  )
                  : _mondayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("TUESDAY", style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _tuesdayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _tuesdayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _tuesdayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: tuesdayStart!);
                        if (newTime != null){
                          setState(() {
                            tuesdayStart = newTime;
                          });
                        }
                      },
                      child: Text("${tuesdayStart!.hour.toString().padLeft(2, '0')} : ${tuesdayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: tuesdayFinish!);
                        if (newTime != null){
                          setState(() {
                            tuesdayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${tuesdayFinish!.hour.toString().padLeft(2, '0')} : ${tuesdayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _tuesdayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("WEDNESDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _wednesdayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _wednesdayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _wednesdayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: wednesdayStart!);
                        if (newTime != null){
                          setState(() {
                            wednesdayStart = newTime;
                          });
                        }
                      },
                      child: Text("${wednesdayStart!.hour.toString().padLeft(2, '0')} : ${wednesdayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: wednesdayFinish!);
                        if (newTime != null){
                          setState(() {
                            wednesdayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${wednesdayFinish!.hour.toString().padLeft(2, '0')} : ${wednesdayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _wednesdayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("THURSDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _thursdayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _thursdayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _thursdayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: thursdayStart!);
                        if (newTime != null){
                          setState(() {
                            thursdayStart = newTime;
                          });
                        }
                      },
                      child: Text("${thursdayStart!.hour.toString().padLeft(2, '0')} : ${thursdayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: thursdayFinish!);
                        if (newTime != null){
                          setState(() {
                            thursdayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${thursdayFinish!.hour.toString().padLeft(2, '0')} : ${thursdayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _thursdayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("FRIDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _fridayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _fridayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _fridayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: fridayStart!);
                        if (newTime != null){
                          setState(() {
                            fridayStart = newTime;
                          });
                        }
                      },
                      child: Text("${fridayStart!.hour.toString().padLeft(2, '0')} : ${fridayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: fridayFinish!);
                        if (newTime != null){
                          setState(() {
                            fridayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${fridayFinish!.hour.toString().padLeft(2, '0')} : ${fridayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _fridayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("SATURDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _saturdayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _saturdayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _saturdayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: saturdayStart!);
                        if (newTime != null){
                          setState(() {
                            saturdayStart = newTime;
                          });
                        }
                  },
                      child: Text("${saturdayStart!.hour.toString().padLeft(2, '0')} : ${saturdayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: saturdayFinish!);
                        if (newTime != null){
                          setState(() {
                            saturdayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${saturdayFinish!.hour.toString().padLeft(2, '0')} : ${saturdayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _saturdayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("SUNDAY", style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _sundayAvailability,
                      onChanged: (String? newValue) {
                        setState(() {
                          _sundayAvailability = newValue;
                        });
                      },
                      items: <String>[
                        'Available',
                        'Not Available',
                      ]
                          .map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                20.0),
                            borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              _sundayAvailability == "Available"
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: sundayStart!);
                        if (newTime != null){
                          setState(() {
                            sundayStart = newTime;
                          });
                        }
                      },
                      child: Text("${sundayStart!.hour.toString().padLeft(2, '0')} : ${sundayStart!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),)),
                  Text("---"),
                  GestureDetector(
                      onTap: ()async{
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: sundayFinish!);
                        if (newTime != null){
                          setState(() {
                            sundayFinish = newTime;
                          });
                        }
                      },
                      child: Text("${sundayFinish!.hour.toString().padLeft(2, '0')} : ${sundayFinish!.minute.toString().padLeft(2, '0')}",style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
                ],
              )
                  : _sundayAvailability == "Not Available"
                  ?SizedBox()
                  :SizedBox(),
              SizedBox(height: 45,),
              ElevatedButton(
                onPressed: () {
                  updateAvailability();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        24, 22, 106, 1),
                    padding: const EdgeInsets.fromLTRB(
                        80.0, 10.0, 80.0, 10.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0),
                    )
                ), child: const Text(
                "Update Availability",
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
    );
  }
}
