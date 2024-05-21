import 'package:amigos_ver1/location_Identifier_Results/sampleResult.dart';
import 'package:amigos_ver1/location_Identifier_Results/sampleResultMap.dart';
import 'package:flutter/material.dart';

import '../services/map_services.dart';

class SampleResultTabs extends StatefulWidget {
  final String destinationResult;
  final String imageUrl;
  // final String placeId;
  const SampleResultTabs({super.key, required this.destinationResult, required this.imageUrl});

  @override
  State<SampleResultTabs> createState() => _SampleResultTabsState();
}

class _SampleResultTabsState extends State<SampleResultTabs> {

  int _currentIndex = 0;
  List<Widget> tabs = [];
  late final String idPlace;

  @override
  void initState() {
    super.initState();
    initializeTabs();
  }

  Future<void> initializeTabs() async {
    await mapServiceTasks();
    tabs = [
      SampleResult(destinationResult: widget.destinationResult, imageUrl: widget.imageUrl),
      SampleResultMap(placeId: idPlace),
    ];
    setState(() {});
  }

  Future<void> mapServiceTasks() async {
    String destination = widget.destinationResult;
    idPlace = (await MapServices().getPlaceId(destination))!;
    if (idPlace != null) {
      print('Place ID for $destination: $idPlace');
    } else {
      print('Failed to get place ID for $destination');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
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
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
        elevation: 0,
        title: const Text("DESTINATION FINDER",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromRGBO(43, 52, 140, 1),
        elevation: 0,
        iconSize: 25,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded, color: Colors.white), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined, color: Colors.white), label: ''),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
