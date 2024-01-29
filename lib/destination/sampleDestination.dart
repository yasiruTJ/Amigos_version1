import 'package:amigos_ver1/travelGuideProfile/travelGuideGrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SampleDestination extends StatefulWidget {
  const SampleDestination({super.key});

  @override
  State<SampleDestination> createState() => _SampleDestinationState();
}


class _SampleDestinationState extends State<SampleDestination> {

  bool _isFavourited = false;

  void toggleFavourite(){
    setState(() {
      if(_isFavourited){
        _isFavourited = false;
        Fluttertoast.showToast(
            msg: "Removed from favourites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //add the code to remove info from favourites page
      }else{
        _isFavourited = true;
        Fluttertoast.showToast(
            msg: "Added to favourites",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //add the code to pass the info to favourites page
      }
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
        title: const Text("EXPLORE",style: TextStyle(
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
              FlutterCarousel(
                options: CarouselOptions(
                  height: 400.0,
                  showIndicator: true,
                  slideIndicator: CircularSlideIndicator(
                      currentIndicatorColor: Color.fromRGBO(24, 22, 106, 1),
                      indicatorBorderColor: Colors.white
                  ),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  pauseAutoPlayOnTouch: true,
                ),
                items: [1,2,3,4,5,6,7,8,9,10].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            width: 380,
                            height: 354,
                            decoration: ShapeDecoration(
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://via.placeholder.com/380x354"),
                                fit: BoxFit.fill,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                      );
                    },
                  );
                }).toList(),
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
                              fontWeight: FontWeight.bold,
                          ),),
                        const SizedBox(width: 70.0,),
                        IconButton(
                            onPressed: (){
                              toggleFavourite();
                            },
                            icon: (_isFavourited
                            ? const Icon(Icons.star_outlined)
                            : const Icon(Icons.star_border)),
                          color: const Color.fromRGBO(24, 22, 106, 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Column(
                      children: [
                        const Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                          ),
                        ),
                        const SizedBox(height: 20.0,),
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
                        const SizedBox(height: 30.0,),
                        Column(
                          children: [
                            const Text("Available Tour Guides",
                            style: TextStyle(
                              color: Color.fromRGBO(24, 22, 106, 1),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500
                            ),),
                            const SizedBox(height: 20.0,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute
                                  (builder: (context)=> const TravelGuideGrid()));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                    radius: 40,
                                    child: Icon(Icons.person,color: Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(width: 30.0,),
                                  CircleAvatar(
                                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                    radius: 40,
                                    child: Icon(Icons.person,color: Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                  SizedBox(width: 30.0,),
                                  CircleAvatar(
                                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                                    radius: 40,
                                    child: Icon(Icons.person,color: Color.fromRGBO(104, 100, 247, 1)),
                                  ),
                                ],
                              ),
                            )
                          ],
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
