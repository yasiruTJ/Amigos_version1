import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:amigos_ver1/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SampleResultMap extends StatefulWidget {
  final String placeId;
  const SampleResultMap({super.key, required this.placeId});

  @override
  State<SampleResultMap> createState() => _SampleResultMapState();
}

class _SampleResultMapState extends State<SampleResultMap> {
  late final ScrollController _horizontal;
  LatLng? location;
  bool isLoading = false;
  bool mapViewCLicked = true;
  bool listViewClicked = false;
  bool restaurantClicked = false;
  bool hotelClicked = false;
  bool cafeClicked = false;
  bool activityClicked = false;
  bool parkClicked = false;
  bool policeClicked = false;
  bool hospitalClicked = false;
  bool supermarketClicked = false;
  List<Marker> markers = [];
  List<Map<String, dynamic>> placesDetails = [];
  List<Uint8List> images = [];
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _horizontal = ScrollController();
    locationTasks();
    initializeMarkerIcons();
  }

  void locationTasks() async {
    setState(() {
      isLoading = true;
    });
    location = await MapServices().fetchLatLngCoordinates(widget.placeId);
    setState(() {
      isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //custom marker icons
  late final Uint8List restaurantIcon;
  late final Uint8List hotelIcon;
  late final Uint8List cafeIcon;
  late final Uint8List activityIcon;
  late final Uint8List parkIcon;
  late final Uint8List policeIcon;
  late final Uint8List hospitalIcon;
  late final Uint8List supermarketIcon;

  void initializeMarkerIcons() async {
    await setRestaurantIcon();
    await setHotelIcon();
    await setCafeIcon();
    await setActivityIcon();
    await setParkIcon();
    await setPoliceIcon();
    await setHospitalIcon();
    await setSupermarketIcon();
  }

  Uint8List? markerIcon;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<List<String>> passImageReference(String photoReference, int maxImages) async {
    final images = await MapServices().fetchPhotoUrls(photoReference, maxImages);
    return images;
  }

  String getPriceLevel(int priceLevel) {
    switch (priceLevel) {
      case 0:
        return "Free";
      case 1:
        return "Inexpensive";
      case 2:
        return "Moderate";
      case 3:
        return "Expensive";
      case 4:
        return "Very Expensive";
      default:
        return "No information found";
    }
  }

  // Function to update the markers after fetching details
  void updateMarkers(List<dynamic> placesList) {
    setState(() {
      markers = placesList.map((place) {
        final name = place['name'];
        final lat = place['geometry']['location']['lat'];
        final lng = place['geometry']['location']['lng'];
        return Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
          icon: BitmapDescriptor.fromBytes(markerIcon!),
        );
      }).toList();
    });
  }



  Future<void> setRestaurantIcon() async {
    restaurantIcon = await getBytesFromAsset('assets/restaurants.png', 85);
  }

  Future<void> setHotelIcon() async {
    hotelIcon = await getBytesFromAsset('assets/hotels.png', 85);
  }

  Future<void> setCafeIcon() async {
    cafeIcon = await getBytesFromAsset('assets/cafe.png', 85);
  }

  Future<void> setActivityIcon() async {
    activityIcon = await getBytesFromAsset('assets/activity.png', 85);
  }

  Future<void> setParkIcon() async {
    parkIcon = await getBytesFromAsset('assets/birds.png', 85);
  }

  Future<void> setPoliceIcon() async {
    policeIcon = await getBytesFromAsset('assets/police.png', 85);
  }

  Future<void> setHospitalIcon() async {
    hospitalIcon = await getBytesFromAsset('assets/hospital.png', 85);
  }

  Future<void> setSupermarketIcon() async {
    supermarketIcon = await getBytesFromAsset('assets/supermarket.png', 85);
  }

  //restaurants
  void fetchRestaurants() async {
    final restaurantList = await MapServices()
        .getRestaurants(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/restaurants.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      restaurantList.forEach((restaurant) async {
        final name = restaurant['name'];
        final rating = restaurant['rating'] ?? "0.0";
        final price = restaurant['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = restaurant['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = restaurant['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(restaurantList);
        }
      });
    });
  }

  //hotels
  void fetchHotels() async {
    final hotelList = await MapServices()
        .getHotels(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/hotels.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      hotelList.forEach((hotel) async {
        final name = hotel['name'];
        final rating = hotel['rating'] ?? "0.0";
        final price = hotel['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = hotel['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = hotel['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(hotelList);
        }
      });
    });
  }

  //cafes
  void fetchCafes() async {
    final cafeList = await MapServices()
        .getCafes(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/cafe.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      cafeList.forEach((cafe) async {
        final name = cafe['name'];
        final rating = cafe['rating'] ?? "0.0";
        final price = cafe['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = cafe['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = cafe['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(cafeList);
        }
      });
    });
  }

  //activities
  void fetchActivities() async {
    final activitiesList = await MapServices()
        .getActivities(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/activity.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      activitiesList.forEach((activity) async {
        final name = activity['name'];
        final rating = activity['rating'] ?? "0.0";
        final price = activity['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = activity['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = activity['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(activitiesList);
        }
      });
    });
  }

  //parks
  void fetchParks() async {
    final parkList = await MapServices()
        .getParks(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/birds.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      parkList.forEach((park) async {
        final name = park['name'];
        final rating = park['rating'] ?? "0.0";
        final price = park['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = park['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = park['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(parkList);
        }
      });
    });
  }

  //police
  void fetchPolice() async {
    final policeList = await MapServices()
        .getPolice(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/police.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      policeList.forEach((police) async {
        final name = police['name'];
        final rating = police['rating'] ?? "0.0";
        final price = police['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = police['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = police['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(policeList);
        }
      });
    });
  }

  //hospitals
  void fetchHospitals() async {
    final hospitalList = await MapServices()
        .getHospitals(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/hospital.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      hospitalList.forEach((hospital) async {
        final name = hospital['name'];
        final rating = hospital['rating'] ?? "0.0";
        final price = hospital['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = hospital['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = hospital['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(hospitalList);
        }
      });
    });
  }

  //supermarkets
  void fetchSupermarkets() async {
    final supermarketList = await MapServices().getSupermarkets(location!.latitude, location!.longitude, 5000);

    markerIcon = await getBytesFromAsset('assets/supermarket.png', 75);
    setState(() {
      markers = [];
      placesDetails.clear();
      supermarketList.forEach((supermarket) async {
        final name = supermarket['name'];
        final rating = supermarket['rating'] ?? "0.0";
        final price = supermarket['price_level'];
        final priceLev = getPriceLevel(price ?? 0);
        final photos = supermarket['photos'] ?? [];
        final photoReference = photos.isNotEmpty ? photos[0]['photo_reference'] : null;

        if (photoReference != null) {
          final images = await passImageReference(photoReference,10);
          final openStatus = supermarket['opening_hours'];
          final openState = openStatus != null ? (openStatus['open_now'] as bool?) ?? false : false;
          placesDetails.add({'name': name, 'rating': rating, 'openStatus': openState, 'priceLevel': priceLev, 'images': images});

          // After adding the place details, update the markers
          updateMarkers(supermarketList);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
        child: Column(
          children: [
            Container(
              width: 170,
              decoration: BoxDecoration(
                color: Color.fromRGBO(202, 201, 255, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mapViewCLicked = true;
                            listViewClicked = false;
                          });
                        },
                        child: Text(
                          "Map View",
                          style: TextStyle(
                              color: mapViewCLicked? const Color.fromRGBO(
                                  104, 100, 247, 1) : Colors.white,
                              fontWeight: mapViewCLicked? FontWeight.bold : FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(
                          color:
                          Color.fromRGBO(104, 100, 247, 1),),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listViewClicked = true;
                            mapViewCLicked = false;
                          });
                        },
                        child: Text(
                          "List View",
                          style: TextStyle(
                              color: listViewClicked? const Color.fromRGBO(
                                  104, 100, 247, 1) : Colors.white,
                              fontWeight: listViewClicked? FontWeight.bold: FontWeight.normal),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Scrollbar(
              thumbVisibility: true,
              controller: _horizontal,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color.fromRGBO(
                                202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = true;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchRestaurants();
                              },
                              icon: restaurantClicked? const Icon(
                                Icons.table_restaurant,
                                size: 25.0,
                              ) :
                              Icon(Icons.table_restaurant_outlined, size: 25.0,),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Restaurants",
                            style: TextStyle(
                                color: const Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: restaurantClicked? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color.fromRGBO(
                                202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = true;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchHotels();
                              },
                              icon: hotelClicked? const Icon(
                                Icons.hotel_sharp,
                                size: 25.0,
                              ): Icon(Icons.local_hotel_outlined),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Hotels",
                            style: TextStyle(
                                color: const Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: hotelClicked? FontWeight.bold: FontWeight.normal),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color.fromRGBO(
                                202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = true;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchCafes();
                              },
                              icon: cafeClicked? const Icon(
                                Icons.coffee_sharp,
                                size: 25.0,
                              ):const Icon(
                                Icons.coffee_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Cafes",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: cafeClicked? FontWeight.bold: FontWeight.normal),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = true;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchActivities();
                              },
                              icon: activityClicked? const Icon(
                                Icons.directions_boat_filled_sharp,
                                size: 25.0,
                              ) : const Icon(
                                Icons.directions_boat_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Activities",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: activityClicked? FontWeight.bold: FontWeight.normal),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = true;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchParks();
                              },
                              icon: parkClicked? const Icon(
                                Icons.park_sharp,
                                size: 25.0,
                              ) : const Icon(
                                Icons.park_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Parks",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: parkClicked? FontWeight.bold: FontWeight.normal),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = true;
                                  hospitalClicked = false;
                                  supermarketClicked = false;
                                });
                                fetchPolice();
                              },
                              icon: policeClicked? const Icon(
                                Icons.local_police_sharp,
                                size: 25.0,
                              ) : const Icon(
                                Icons.local_police_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Police",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: policeClicked? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = true;
                                  supermarketClicked = false;
                                });
                                fetchHospitals();
                              },
                              icon: hospitalClicked? const Icon(
                                Icons.local_hospital_sharp,
                                size: 25.0,
                              ) : const Icon(
                                Icons.local_hospital_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Hospitals",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: hospitalClicked? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 35.0,
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(202, 201, 255, 1),
                            radius: 30,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  restaurantClicked = false;
                                  hotelClicked = false;
                                  cafeClicked = false;
                                  activityClicked = false;
                                  parkClicked = false;
                                  policeClicked = false;
                                  hospitalClicked = false;
                                  supermarketClicked = true;
                                });
                                fetchSupermarkets();
                              },
                              icon: supermarketClicked? const Icon(
                                Icons.shopping_cart_sharp,
                                size: 25.0,
                              ) : const Icon(
                                Icons.shopping_cart_outlined,
                                size: 25.0,
                              ),
                              color:
                              Color.fromRGBO(104, 100, 247, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Supermarkets",
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    104, 100, 247, 1),
                                fontWeight: supermarketClicked? FontWeight.bold: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            mapViewCLicked
                ? location != null
                ? Container(
              height: 545,
              child: GoogleMap(
                mapType: MapType.terrain,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: location!,
                  zoom: 15.0,
                ),
                markers: Set.from([
                  ...markers,
                  Marker(
                    markerId: MarkerId('location'),
                    position: location!,
                  )
                ]),
              ),
            )
                : const Center(
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
                    "Loading locations on the map...",
                    style: TextStyle(
                        color: Color.fromRGBO(24, 22, 106, 1),
                        fontSize: 15.0),
                  ),
                ],
              ),
            )
                : Text("${placesDetails.length} results retrieved",
              style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),),
            SizedBox(height: 10.0,),
            Expanded(
              child: ListView.builder(
                itemCount: placesDetails.length,
                itemBuilder: (context, index) {
                  final place = placesDetails[index];
                  final name = place['name'];
                  final rating = place['rating'];
                  final openStatus = place['openStatus'];
                  final price = place['priceLevel'];
                  final List<String> images = place['images'];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                openStatus ? 'OPEN' : 'CLOSE',
                                style: TextStyle(
                                  color: openStatus ? Colors.green : Colors.red,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Display images in a horizontal list
                          Container(
                            height: 200, // Adjust the height as needed
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    images[index],
                                    width: 350,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          // Display rating, distance, and price
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              SizedBox(width: 4),
                              Text(
                                '$rating',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 20),
                              Icon(Icons.price_change_sharp, size: 20, color: price == "Expensive" ? Colors.red : price == "Moderate" ? Colors.orange : Colors.green),
                              SizedBox(width: 4),
                              Text(
                                price,
                                style: TextStyle(
                                  color: price == "Expensive" ? Colors.red : price == "Moderate" ? Colors.orange : Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
