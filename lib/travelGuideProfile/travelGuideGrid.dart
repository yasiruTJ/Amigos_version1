import 'package:amigos_ver1/destination/guideProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelGuideGrid extends StatefulWidget {
  final String placeName;

  const TravelGuideGrid({super.key, required this.placeName});

  @override
  State<TravelGuideGrid> createState() => _TravelGuideGridState();
}

class _TravelGuideGridState extends State<TravelGuideGrid> {
  String? imageUrl;
  List<String> placeNames = [];
  List<String> firstNames = [];
  List<String> lastNames = [];
  List<String> emails = [];
  Map<String, String> guideImages = {};
  Map<String, dynamic> guideDetails = {};

  //Dropdown selectors
  String? _selectedNationality;
  String? _selectedSpokenLanguage;
  String? _selectedPriceRange;

  @override
  void initState() {
    super.initState();
    firstNames.clear();
    lastNames.clear();
    emails.clear();
    guideImages.clear();
    loadGuideTasks();
  }

  Future<String> loadGuideTasks() async {
    setState(() {
      loadGuideDetails();
    });
    return 'success';
  }

  void loadGuideDetails() async {
    try {
      List<String> documents = await findGuidesForLocation("guideDetails",
          ["Location 1", "Location 2", "Location 3"], widget.placeName);

      // Process the documents returned by the function
      print("Documents with matching value: $documents");

      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('guideDetails');

      firstNames.clear();
      lastNames.clear();
      emails.clear();
      guideDetails.clear();
      // Iterate through the list of document IDs
      for (String docId in documents) {
        // Query Firestore for the document with the ID
        emails.add(docId);
        DocumentSnapshot snapshot = await collectionRef.doc(docId).get();

        if (snapshot.exists) {
          // Add the document data to the guideDetails map
          String firstName = snapshot
              .get("firstName");
          String lastName = snapshot
              .get("lastName");

          // Add the fields to the guideDetails map
          guideDetails[docId] = {"firstName": firstName, "lastName": lastName};
        }
      }

      setState(() {
        guideDetails.forEach((key, value) {
          String firstName = value['firstName'] ?? '';
          firstNames.add(firstName);
          String lastName = value['lastName'] ?? '';
          lastNames.add(lastName);
        });

        for (String email in emails) {
          final url = getProfilePic(email);
        }
      });
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error loading guide details: $e');
    }
  }

  Future<String?> getProfilePic(String email) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('guide_profile_pictures/$email/profilePic.jpg');
    imageUrl = await ref.getDownloadURL();
    String? url = imageUrl ?? "";
    setState(() {
      guideImages[email] = imageUrl!;
    });
    return url;
  }

  Future<List<String>> findGuidesForLocation(
      String collectionName, List<String> fields, dynamic value) async {
    List<String> documentsWithMatchingValue = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          // Iterate through each field to check if any of them contains the specified value
          for (String field in fields) {
            if (data.containsKey(field) && data[field] == value) {
              documentsWithMatchingValue.add(doc.id);
              break; // Break out of the loop once a matching field is found
            }
          }
        }
      });

      return documentsWithMatchingValue;
    } catch (e) {
      print('Error finding documents with value: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<String>> findGuidesForLocationAndNationality(
      String collectionName,
      List<String> fields,
      String placeName,
      String nationality,
      String spokenLanguage,
      String price) async {
    List<String> documentsWithMatchingValue = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collectionName).get();

      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

          String range = "";
          if((data.containsKey("Location 1") && data["Location 1"] == placeName ||
              data.containsKey("Location 2") && data["Location 2"] == placeName ||
              data.containsKey("Location 3") && data["Location 3"] == placeName) &&
              (data.containsKey("Spoken Language 1") && data["Spoken Language 1"] == spokenLanguage ||
                  data.containsKey("Spoken Language 2") && data["Spoken Language 2"] == spokenLanguage) &&
              data.containsKey("Nationality") && data["Nationality"] == nationality &&
              data.containsKey("charges")){
            int charge = int.parse(data["charges"]);
            if (charge >= 50){
              range = "Expensive(50 £+)";
            }else if (25 <= charge && charge < 50){
              range = "Moderate(25 £ - 50 £)";
            }else{
              range = "Cheap (0 £ - 25 £)";
            }
          }

          // Check if both placeName and nationality match
          if ((data.containsKey("Location 1") && data["Location 1"] == placeName ||
              data.containsKey("Location 2") && data["Location 2"] == placeName ||
              data.containsKey("Location 3") && data["Location 3"] == placeName) &&
              (data.containsKey("Spoken Language 1") && data["Spoken Language 1"] == spokenLanguage ||
                  data.containsKey("Spoken Language 2") && data["Spoken Language 2"] == spokenLanguage) &&
              data.containsKey("Nationality") && data["Nationality"] == nationality && range == price) {
            documentsWithMatchingValue.add(doc.id);
          }
        }
      });

      return documentsWithMatchingValue;
    } catch (e) {
      print('Error finding documents with value: $e');
      return []; // Return an empty list in case of an error
    }
  }


  void clearFilters(){
    setState(() {
      _selectedNationality = null;
      _selectedSpokenLanguage = null;
      _selectedPriceRange = null;
    });
    loadGuideDetails();
  }

  void findFilteredData()async{
    if (_selectedNationality != null && _selectedSpokenLanguage != null && _selectedPriceRange != null){
      try {
        List<String> documents = await findGuidesForLocationAndNationality(
            "guideDetails",
            ["Location 1", "Location 2", "Location 3", "Nationality", "Spoken Language 1", "Spoken Language 2"],
            widget.placeName,
            _selectedNationality ?? "",
            _selectedSpokenLanguage ?? "",
            _selectedPriceRange ?? ""
        );

        // Process the documents returned by the function
        print("Documents with matching value: $documents");

        CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('guideDetails');

        // Iterate through the list of document IDs
        firstNames.clear();
        lastNames.clear();
        emails.clear();
        guideDetails.clear();
        for (String docId in documents) {
          // Query Firestore for the document with the ID
          emails.add(docId);
          DocumentSnapshot snapshot = await collectionRef.doc(docId).get();

          if (snapshot.exists) {
            // Add the document data to the guideDetails map
            String firstName = snapshot
                .get("firstName");
            String lastName = snapshot
                .get("lastName");

            // Add the fields to the guideDetails map
            guideDetails[docId] = {"firstName": firstName, "lastName": lastName};
          }
        }

        setState(() {
          guideDetails.forEach((key, value) {
            String firstName = value['firstName'] ?? '';
            firstNames.add(firstName);
            String lastName = value['lastName'] ?? '';
            lastNames.add(lastName);
          });
        });

      } catch (e) {
        // Handle any errors that occur during the process
        print('Error loading guide details: $e');
      }
    }
    else{
      loadGuideDetails();
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findGuidesForLocation("guideDetails",
          ["Location 1", "Location 2", "Location 3"], widget.placeName),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
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
                ],
              ),
            ),
          ); // Show a loading indicator while waiting for the future to complete
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show an error message if the future throws an error
        } else {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
              elevation: 0,
              title: const Text(
                "FIND A GUIDE FOR YOU",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 50.0),
              child: firstNames.isNotEmpty || lastNames.isNotEmpty || guideImages.isNotEmpty
                  ? Column(
                    children: [
                      Container(
                        height: 265,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text("Nationality : "),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedNationality,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedNationality = newValue;
                                        });
                                      },
                                      items: <String>[
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
                                          child: Text(value, style: TextStyle(
                                            fontSize: 15
                                          ),),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.0,),
                              Row(
                                children: [
                                  const Text("Language : "),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedSpokenLanguage,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedSpokenLanguage = newValue;
                                        });
                                      },
                                      items: <String>[
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
                                        contentPadding: const EdgeInsets.all(5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            borderSide: BorderSide(color: Colors.black)
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.0,),
                              Row(
                                children: [
                                  const Text("Price (hourly) : "),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedPriceRange,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedPriceRange = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'Cheap (0 £ - 25 £)',
                                        'Moderate(25 £ - 50 £)',
                                        'Expensive(50 £+)'
                                      ]
                                          .map<DropdownMenuItem<String>>((
                                          String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0),
                                            borderSide: BorderSide(color: Colors.black),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      clearFilters();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            24, 22, 106, 1),
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              25.0),
                                        )
                                    ), child: const Text(
                                    "CLEAR",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  ),
                                  SizedBox(width: 10,),
                                  ElevatedButton(
                                    onPressed: () {
                                      findFilteredData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            24, 22, 106, 1),
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 10.0),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              25.0),
                                        )
                                    ), child: const Text(
                                    "FILTER",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                height: 400, // Adjust the height as needed
                child: guideDetails.isNotEmpty?
                ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: (guideDetails.length / 3).ceil(), // Calculate the number of rows needed
                      itemBuilder: (context, rowIndex) {
                        return SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (int i = rowIndex * 3; i < (rowIndex + 1) * 3; i++)
                                if (i < guideDetails.length)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => TravelGuideProfile(
                                            guideEmail: emails[i],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20,),
                                        CircleAvatar(
                                          radius: 55.0,
                                          backgroundColor: Colors.white,
                                          backgroundImage: guideImages[emails[i]] != ""
                                              ? NetworkImage(guideImages[emails[i]] ?? "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png" )
                                              : const NetworkImage(
                                              "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png"),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(firstNames[i] + " " + lastNames[i]),
                                        SizedBox(height: 20,)
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        );
                      },
                )
                    : const Text("No tour guides found")
              ),
                    ],
                  )
                  : Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      color: Color.fromRGBO(24, 22, 106, 1),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "No travel guides available for this location",
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
                      "We are consistently working on improving our services.",
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
              ),
            ),
          );
        }
      },
    );
  }
}
