import 'package:amigos_ver1/destination/sampleDestination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlacesGrid extends StatefulWidget {
  const PlacesGrid({super.key});

  @override
  State<PlacesGrid> createState() => _PlacesGridState();
}

void pushDestinationPage(){

}

class _PlacesGridState extends State<PlacesGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
          elevation: 0,
          title: const Text("POPULAR DESTINATIONS",style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0
          )),
        ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0,20.0,25.0,50.0),
          child: Column(
            children: [
              Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>const SampleDestination()));
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ),
                SizedBox(width: 10.0,),
                Column(
                  children: [
                    Container(
                      width: 110,
                      height: 125,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/115x125"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text("Sample",
                      style: TextStyle(
                        color: const Color.fromRGBO(24, 22, 106, 1),
                        fontWeight: FontWeight.w400,
                      ),)
                  ],
                ),
                SizedBox(width: 10.0,),
                Column(
                  children: [
                    Container(
                      width: 110,
                      height: 125,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/115x125"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Text("Sample",
                      style: TextStyle(
                        color: const Color.fromRGBO(24, 22, 106, 1),
                        fontWeight: FontWeight.w400,
                      ),)
                  ],
                ),
              ],
            ),
              SizedBox(height: 25.0,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0,),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                  SizedBox(width: 10.0,),
                  Column(
                    children: [
                      Container(
                        width: 110,
                        height: 125,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/115x125"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text("Sample",
                        style: TextStyle(
                          color: const Color.fromRGBO(24, 22, 106, 1),
                          fontWeight: FontWeight.w400,
                        ),)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
