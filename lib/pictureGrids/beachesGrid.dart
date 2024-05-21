import 'package:amigos_ver1/destination/destinationTabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../destination/sampleDestinationDetails.dart';
import '../services/map_services.dart';

class BeachesGrid extends StatefulWidget {
  const BeachesGrid({super.key});

  @override
  State<BeachesGrid> createState() => _BeachesGridState();
}

class _BeachesGridState extends State<BeachesGrid> {
  List<Map<String, dynamic>> beaches = [];
  bool isLoading = false;
  TextEditingController beachesEntry = TextEditingController();

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

    beaches = await MapServices().getBeachesUK();

    // Hide loading indicator
    setState(() {
      isLoading = false;
    });
  }

  void retrieveSearch()async{
    setState(() {
      isLoading = true;
    });

    beaches = await MapServices().destinationSearch(beachesEntry.text.trim());

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
        title: const Text("BEACHES",style: TextStyle(
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
              TextFormField(
                controller: beachesEntry,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5.0),
                    hintText: "Discover Beaches",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromRGBO(236, 236, 237, 1),
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: (){
                        retrieveSearch();
                      },
                      color: Colors.black,
                      icon: Icon(Icons.search, size: 25.0,),
                    )),
                autocorrect: true,
                enableSuggestions: true,
              ),
              const SizedBox(height: 15.0,),
              Text(
                "${beaches.length} entries have been retrieved",
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
                  itemCount: beaches.length,
                  itemBuilder: (BuildContext context, int index) {
                    final beach = beaches[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context)=>DestinationTabs(placeId: beach['placeId'], placeName: beach['name'],)));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 330,
                              height: 270,
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
                            const SizedBox(height: 10.0,),
                            Text(
                              beach['name'] ?? 'Unknown',
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
