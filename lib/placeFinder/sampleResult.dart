import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SampleResult extends StatefulWidget {
  const SampleResult({super.key});

  @override
  State<SampleResult> createState() => _SampleResultState();
}

class _SampleResultState extends State<SampleResult> {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40.0,20.0,40.0,40.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 380,
                height: 260,
                decoration: ShapeDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                        "https://via.placeholder.com/380x260"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Lorem Ipsum, dolor sit",
                          style: TextStyle(
                              color: Color.fromRGBO(24, 22, 106, 1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox(width: 70.0,),
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(
                              Icons.star_border_purple500_rounded,
                              size: 35.0,
                            ))
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Column(
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
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
                                      Text("Address",
                                        style: TextStyle(
                                            color: Color.fromRGBO(24, 22, 106, 1),
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(height: 8.0,),
                                      Text("dolor sit amet, consectetur adipiscing",
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
                                    child: Icon(Icons.timer_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Opening times",
                                        style: TextStyle(
                                            color: Color.fromRGBO(24, 22, 106, 1),
                                            fontWeight: FontWeight.bold
                                        ),),
                                      SizedBox(height: 8.0,),
                                      Text("dolor sit amet, consectetur adipiscing",
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
                                    child: Icon(Icons.price_change_outlined,color: Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Ticket Prices",
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
                                    child: Icon(Icons.phone,color: Color.fromRGBO(104, 100, 247, 1)),
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
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0,),
                                  Column(
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 215,
                                        decoration: ShapeDecoration(
                                          image: const DecorationImage(
                                            image: NetworkImage(
                                                "https://via.placeholder.com/220x215"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
