import 'package:amigos_ver1/destination/destinationTabs.dart';
import 'package:amigos_ver1/destination/sampleDestinationDetails.dart';
import 'package:amigos_ver1/pictureGrids/beachesGrid.dart';
import 'package:amigos_ver1/pictureGrids/favouritesGrid.dart';
import 'package:amigos_ver1/pictureGrids/mountainsGrid.dart';
import 'package:amigos_ver1/pictureGrids/popularPlacesGrid.dart';
import 'package:amigos_ver1/services/map_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> popularDestinations = [];
  List<Map<String, dynamic>> mountains = [];
  List<Map<String, dynamic>> beaches = [];
  List<Map<String, dynamic>> favPlaces = [];
  bool isLoading = false;
  List<String> placeIds = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
    dashboardLoadingTasks();
  }

  void dashboardLoadingTasks() async {
    setState(() {
      isLoading = true;
    });

    popularDestinations = await MapServices().getPopularDestinationsUK();
    mountains = await MapServices().getMountainsUK();
    beaches = await MapServices().getBeachesUK();
    final favourites = await loadFavourites();

    // Iterate over the favourites map and extract IDs
    favourites.forEach((key, value) {
      placeIds.add("$value");
    });

    // Fetch details for favourite places
    favPlaces = await MapServices().fetchFavPlaceDetails(placeIds);

    setState(() {
      isLoading = false;
    });
  }


  Future<Map<String, dynamic>> loadFavourites() async{
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersCollection = firestore.collection('favourites');
      String? documentId = user?.email;

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

  //textfield controller

  TextEditingController controllerPlaces = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: isLoading
        ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(24, 22, 106, 1)),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 15.0,),
            Text("Loading the dashboard...",
            style: TextStyle(
              color: Color.fromRGBO(24, 22, 106, 1),
              fontSize: 15.0
            ),),
          ],
        ),
      )
      :Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular',
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const PopularPlacesGrid()));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color.fromRGBO(45, 87, 124, 1),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Scrollbar(
                  child: SingleChildScrollView(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: popularDestinations.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final destination = popularDestinations[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context,
                                        CupertinoPageRoute(builder: (context)=> DestinationTabs(placeId: destination['placeId'], placeName: destination['name'],)));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 157,
                                            height: 144,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(destination['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10.0,),
                                          Text(
                                            destination['name'] ?? 'Unknown',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Color.fromRGBO(24, 22, 106, 1)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mountains',
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MountainsGrid()));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color.fromRGBO(45, 87, 124, 1),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 200, // Set a fixed height
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mountains.length,
                              itemBuilder: (BuildContext context, int index) {
                                final mountain = mountains[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                      CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: mountain['placeId'], placeName: mountain['name'],)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: 157,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(mountain['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(
                                          mountain['name'] ?? 'Unknown',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color.fromRGBO(24, 22, 106, 1)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Beaches',
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const BeachesGrid()));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color.fromRGBO(45, 87, 124, 1),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 200, // Set a fixed height
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: beaches.length,
                              itemBuilder: (BuildContext context, int index) {
                                final beach = beaches[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                      CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: beach['placeId'], placeName: beach['name'],)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: 157,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(beach['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(
                                          beach['name'] ?? 'Unknown',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Color.fromRGBO(24, 22, 106, 1)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     const Text(
                      'Favourites',
                      style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => FavouritesGrid(placeIds: placeIds)));
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color.fromRGBO(45, 87, 124, 1),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                favPlaces.isNotEmpty
                ?SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 200, // Set a fixed height
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: favPlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                final placeName = favPlaces[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: placeName['placeId'], placeName: placeName['name'],)));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: 157,
                                          height: 144,
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(placeName['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                              fit: BoxFit.fill,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(
                                          placeName['name'],
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color.fromRGBO(24, 22, 106, 1)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                )
                    :Container(
                        height: 200,
                        width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off_outlined, color: Color.fromRGBO(24, 22, 106, 1),),
                            SizedBox(height: 10.0,),
                            Text("No favourite destinations found",
                              style: TextStyle(
                                color: Color.fromRGBO(24, 22, 106, 1),
                                fontSize: 15,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),),
                            SizedBox(height: 10.0,),
                            Text("Explore more and add some destinations as your favourites!",
                              style: TextStyle(
                                color: Color.fromRGBO(24, 22, 106, 1),
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                height: 0,
                              ),),
                          ],
                        )
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
