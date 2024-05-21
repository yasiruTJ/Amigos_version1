import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/destinationTabs.dart';
import '../services/map_services.dart';

class FavouritesGrid extends StatefulWidget {
  final List<String> placeIds;
  const FavouritesGrid({super.key, required this.placeIds});

  @override
  State<FavouritesGrid> createState() => _FavouritesGridState();
}

class _FavouritesGridState extends State<FavouritesGrid> {

  List<Map<String, dynamic>> favPlaces = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    gridLoadingTasks();
  }

  void gridLoadingTasks() async{
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    favPlaces = await MapServices().fetchFavPlaceDetails(widget.placeIds);

    // Hide loading indicator
    setState(() {
      isLoading = false;
    });
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
        title: const Text("FAVOURITES",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body:isLoading?
      const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator( // Circular progress indicator with a dashed appearance
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(24, 22, 106, 1)),
              strokeWidth: 3.0,
            ),
            SizedBox(height: 15.0,),
            Text("Fetching locations...",
              style: TextStyle(
                  color: Color.fromRGBO(24, 22, 106, 1),
                  fontSize: 15.0
              ),),
          ],
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0,20.0,25.0,50.0),
          child: Column(
            children: [
              Text(
                "${favPlaces.length} entries have been retrieved",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(24, 22, 106, 1)
                ),
              ),
              const SizedBox(height: 20.0,),
              SizedBox(
                height: 650,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: favPlaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    final favPlaceName = favPlaces[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: favPlaceName['placeId'], placeName: favPlaceName['name'],)));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 330,
                              height: 270,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(favPlaceName['imageUrl'] ?? "https://via.placeholder.com/157x144"),
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            Text(
                              favPlaceName['name'] ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Color.fromRGBO(24, 22, 106, 1)
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 20.0,)
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
      ),
    );
  }
}
