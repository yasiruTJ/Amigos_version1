import 'package:amigos_ver1/destination/sampleDestinationDetails.dart';
import 'package:amigos_ver1/destination/sampleDestinationMap.dart';
import 'package:flutter/material.dart';

class DestinationTabs extends StatefulWidget {
  final String placeId;
  final String placeName;
  const DestinationTabs({super.key, required this.placeId, required this.placeName});

  @override
  State<DestinationTabs> createState() => _DestinationTabsState();
}


class _DestinationTabsState extends State<DestinationTabs> {

  int _currentIndex = 0;
  List<Widget> tabs = [];

  @override
  void initState(){
    super.initState();

    tabs = [
      SampleDestination(placeId: widget.placeId,placeName: widget.placeName,),
      SampleDestinationMap(placeId: widget.placeId),
    ];
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
        title: const Text("EXPLORE",style: TextStyle(
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
