import 'package:amigos_ver1/travelGuideProfile/guideProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelGuideGrid extends StatefulWidget {
  const TravelGuideGrid({super.key});

  @override
  State<TravelGuideGrid> createState() => _TravelGuideGridState();
}

class _TravelGuideGridState extends State<TravelGuideGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
        elevation: 0,
        title: const Text("TRAVEL GUIDES",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0,20.0,25.0,50.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context)=> TravelGuideProfile()));
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                            radius: 55.0,
                            backgroundColor: Colors.white,
                            child: Image.asset('assets/logo.png',fit: BoxFit.cover,)
                        ),
                        SizedBox(height: 10.0,),
                        const Text("Sample",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w400,
                          ),)
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/logo.png',fit: BoxFit.cover,)
                      ),
                      SizedBox(height: 10.0,),
                      const Text("Sample",
                        style: TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.white,
                          child: Image.asset('assets/logo.png',fit: BoxFit.cover,)
                      ),
                      SizedBox(height: 10.0,),
                      const Text("Sample",
                        style: TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
