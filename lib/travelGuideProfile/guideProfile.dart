import 'package:flutter/material.dart';

class TravelGuideProfile extends StatefulWidget {
  const TravelGuideProfile({super.key});

  @override
  State<TravelGuideProfile> createState() => _TravelGuideProfileState();
}

class _TravelGuideProfileState extends State<TravelGuideProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(24, 22, 106, 1),
        elevation: 0,
        title: const Text("GET IN TOUCH WITH YOUR GUIDE",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(75.0,20.0,75.0,50.0),
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/logo.png',fit: BoxFit.cover,)
                ),
                SizedBox(height: 20.0,),
                Text("Lorem Ipsum",
                  style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height: 30.0,),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.fugiat nulla pariatur. ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color.fromRGBO(24, 22, 106, 1),
                  ),
                ),
                SizedBox(height: 30.0,),
                const Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Languages spoken",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Registration no",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Based on",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Available times",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Prices",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(Icons.location_on_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                        ),
                        SizedBox(width: 20.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Contact details",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.bold
                              ),),
                            SizedBox(height: 8.0,),
                            Text("dolor sit amet",
                              style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontSize: 12.0
                              ),)
                          ],
                        ),
                        // FloatingActionButton(
                        //     onPressed: (){
                        //
                        //     },
                        //   backgroundColor: Color.fromRGBO(214, 217, 244, 1),
                        //   child: Icon(
                        //     Icons.chat_bubble,
                        //     color: Color.fromRGBO(24, 22, 106, 1),
                        //   ),
                        // )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
