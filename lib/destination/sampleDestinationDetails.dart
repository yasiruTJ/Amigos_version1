import 'dart:convert';

import 'package:amigos_ver1/destination/guideProfile.dart';
import 'package:amigos_ver1/guideProfile/guideProfile.dart';
import 'package:amigos_ver1/services/map_services.dart';
import 'package:amigos_ver1/travelGuideProfile/travelGuideGrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SampleDestination extends StatefulWidget {
  final String placeId;
  final String placeName;

  const SampleDestination(
      {super.key, required this.placeId, required this.placeName});

  @override
  State<SampleDestination> createState() => _SampleDestinationState();
}

class _SampleDestinationState extends State<SampleDestination> {
  String? imageUrl;
  late Map<String, dynamic> placeDetails = {};
  late List<String> imageUrls = [];
  List<String> placeNames = [];
  List<String> firstNames = [];
  List<String> lastNames = [];
  List<String> emails = [];
  Map<String, String> guideImages = {};
  bool _isFavourited = false;
  Map<String, dynamic> guideDetails = {};
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    firstNames.clear();
    lastNames.clear();
    emails.clear();
    guideImages.clear();
    mapServiceTasks();
    loadFavourites();
    loadGuideTasks();
  }

  void mapServiceTasks() async {
    String placeId = widget.placeId;

    final placeInfo = await MapServices().getSelectedPlaceInfo(placeId);
    placeDetails = json.decode(placeInfo!);
    final dynamic photosData = placeDetails['photos'];
    imageUrls = photosData != null ? List<String>.from(photosData) : [];
    setState(() {});
  }

  void loadGuideTasks() async {
    setState(() {
      loadGuideDetails();
    });
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

  Future<void> loadGuideDetails() async {
    try {
      List<String> documents = await findGuidesForLocation("guideDetails",
          ["Location 1", "Location 2", "Location 3"], widget.placeName);

      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('guideDetails');

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

      for (String email in emails) {
        getProfilePic(email);
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

  void loadFavourites() async {
    String? documentId = user?.email;
    final placeN = widget.placeName;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(documentId)
        .get();
    if (snapshot.exists) {
      // Document exists, you can access its data
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        placeNames.add(key);
      });

      if (placeNames.contains(placeN)) {
        setState(() {
          _isFavourited = true;
        });
      } else {
        setState(() {
          _isFavourited = false;
        });
      }
    } else {
      print('No Favourites');
    }
    setState(() {});
  }

  void toggleFavourite() {
    setState(() {
      if (_isFavourited) {
        _isFavourited = false;
        removeFromFavourites(widget.placeId, placeDetails['name']);
        Fluttertoast.showToast(
            msg: "Removed From Favourites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {});
      } else {
        _isFavourited = true;
        addToFavourites(widget.placeId, placeDetails['name'], imageUrls[0]);
        Fluttertoast.showToast(
            msg: "Added To Favourites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {});
      }
    });
  }

  Future<void> addToFavourites(
      String placeId, placeName, String imageUrl) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        placeName: placeId,
      };

      CollectionReference usersCollection = firestore.collection('favourites');
      String? documentId = user?.email;

      await usersCollection.doc(documentId).update(data);

      print('Data saved successfully');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  Future<void> removeFromFavourites(String placeId, placeName) async {
    String? documentId = user?.email;
    try {
      await FirebaseFirestore.instance
          .collection('favourites')
          .doc(documentId)
          .update({
        placeName: FieldValue.delete(),
      });
      print('Field successfully deleted');
      setState(() {
        _isFavourited = false;
      });
    } catch (e) {
      print('Error deleting field: $e');
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findGuidesForLocation("guideDetails",
          ["Location 1", "Location 2", "Location 3"], widget.placeName),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                  "Fetching location details...",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1), fontSize: 15.0),
                ),
              ],
            ),
          ); // Show a loading indicator while waiting for the future to complete
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show an error message if the future throws an error
        } else {
          // Once the future completes successfully, build the UI with the data
          return Scaffold(
            backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 50.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterCarousel(
                      options: CarouselOptions(
                        height: 250.0,
                        showIndicator: true,
                        slideIndicator: const CircularSlideIndicator(
                            currentIndicatorColor:
                                Color.fromRGBO(24, 22, 106, 1),
                            indicatorBorderColor: Colors.white),
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 500),
                        pauseAutoPlayOnTouch: true,
                      ),
                      items: imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.fill,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            placeDetails['name'] ?? 'Unknown',
                            softWrap: true,
                            style: const TextStyle(
                              color: Color.fromRGBO(24, 22, 106, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 70.0,
                        ),
                        IconButton(
                          onPressed: () {
                            toggleFavourite();
                          },
                          icon: (_isFavourited
                              ? const Icon(Icons.star_outlined)
                              : const Icon(Icons.star_border)),
                          color: _isFavourited
                              ? Colors.orangeAccent
                              : const Color.fromRGBO(24, 22, 106, 1),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Text(
                          placeDetails['summary'] ?? 'No information found',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(202, 201, 255, 1),
                                    radius: 30,
                                    child: Icon(Icons.location_on_outlined,
                                        color:
                                            Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  24, 22, 106, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          placeDetails['address'] ??
                                              'No information found',
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  24, 22, 106, 1),
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(202, 201, 255, 1),
                                    radius: 30,
                                    child: Icon(Icons.timer_outlined,
                                        color:
                                            Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Opening times",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        placeDetails['openDays'] ??
                                            'No information found',
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontSize: 12.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(202, 201, 255, 1),
                                    radius: 30,
                                    child: Icon(Icons.price_change_outlined,
                                        color:
                                            Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Ticket Prices",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        placeDetails['price'] ??
                                            'No information found',
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontSize: 12.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(202, 201, 255, 1),
                                    radius: 30,
                                    child: Icon(Icons.phone,
                                        color:
                                            Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Contact details",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        placeDetails['internationalPhone'] ??
                                            "No information found",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(24, 22, 106, 1),
                                            fontSize: 12.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromRGBO(202, 201, 255, 1),
                                    radius: 30,
                                    child: Icon(Icons.phone,
                                        color:
                                            Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Website",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  24, 22, 106, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          placeDetails['website'] ??
                                              "No information found",
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  24, 22, 106, 1),
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Available Tour Guides",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (context)=> TravelGuideGrid(placeName: widget.placeName,)));
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: Color.fromRGBO(45, 87, 124, 1),
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        firstNames.isNotEmpty ||
                                lastNames.isNotEmpty ||
                                guideImages.isNotEmpty
                            ? Container(
                                height: 180, // Adjust the height as needed
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // Set scroll direction to horizontal
                                  itemCount: guideDetails.length,
                                  itemBuilder: (context, index) {
                                    // Return a CircleAvatar widget for each index
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print(guideImages);
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        TravelGuideProfile(
                                                            guideEmail: emails[
                                                                index])));
                                          },
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 60.0,
                                                backgroundColor: Colors.white,
                                                backgroundImage: guideImages[emails[index]] != ""
                                                    ? NetworkImage(guideImages[emails[index]] ?? "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png" )
                                                    : const NetworkImage(
                                                    "https://www.pngkey.com/png/detail/202-2024792_user-profile-icon-png-download-fa-user-circle.png"),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(firstNames[index] +
                                                  " " +
                                                  lastNames[index])
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        // Add spacing between CircleAvatar widgets
                                      ],
                                    );
                                  },
                                ),
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
                            )
                      ],
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
