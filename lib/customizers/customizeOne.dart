import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomizePg1 extends StatefulWidget {
  const CustomizePg1({super.key});

  @override
  State<CustomizePg1> createState() => _CustomizePg1State();
}

class _CustomizePg1State extends State<CustomizePg1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(214, 217, 244, 1),
      body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(35.0,135.0,35.0,10.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft ,
                          child: Text("Let's Customize",
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Color.fromRGBO(24, 22, 106, 1),
                                fontWeight: FontWeight.bold
                            ),),
                        ),
                        SizedBox(height: 40.0,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("To what type of place would you like to travel?",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color.fromRGBO(24, 22, 106, 1),
                            ),),
                        ),
                        SizedBox(height: 30.0,),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(image: AssetImage("assets/urban.jpeg"),fit: BoxFit.cover, width: 140.0, height: 140.0,)),
                                    SizedBox(height: 20.0,),
                                    Text("Beach Paradise",
                                      style: TextStyle(
                                          color: Color.fromRGBO(24, 22, 106, 1),
                                          fontSize: 15.0,
                                          letterSpacing: 0.5
                                      ),)
                                  ],
                                ),
                                SizedBox(width: 40.0,),
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(image: AssetImage("assets/urban.jpeg"),fit: BoxFit.cover, width: 140.0, height: 140.0,)),
                                    SizedBox(height: 20.0,),
                                    Text("Cultural Adventure",
                                      style: TextStyle(
                                          color: Color.fromRGBO(24, 22, 106, 1),
                                          fontSize: 15.0,
                                          letterSpacing: 0.5
                                      ),)
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 30.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(image: AssetImage("assets/urban.jpeg"),fit: BoxFit.cover, width: 140.0, height: 140.0,)),
                                    SizedBox(height: 20.0,),
                                    Text("Urban Exploration",
                                      style: TextStyle(
                                          color: Color.fromRGBO(24, 22, 106, 1),
                                          fontSize: 15.0,
                                          letterSpacing: 0.5
                                      ),)
                                  ],
                                ),
                                SizedBox(width: 40.0,),
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(image: AssetImage("assets/urban.jpeg"),fit: BoxFit.cover, width: 140.0, height: 140.0,)),
                                    SizedBox(height: 20.0,),
                                    Text("Nature Retreat",
                                      style: TextStyle(
                                          color: Color.fromRGBO(24, 22, 106, 1),
                                          fontSize: 15.0,
                                          letterSpacing: 0.5
                                      ),)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ),
          );
  }
}
