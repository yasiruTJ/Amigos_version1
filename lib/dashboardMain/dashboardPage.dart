import 'package:amigos_ver1/destination/sampleDestination.dart';
import 'package:amigos_ver1/placesGrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //textfield controller

  TextEditingController controllerPlaces = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
          child: Column(
            children: [
              TextFormField(
                controller: controllerPlaces,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5.0),
                    hintText: "Discover Places",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none),
                    fillColor: const Color.fromRGBO(236, 236, 237, 1),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 25.0,
                    )),
                cursorColor: Colors.white,
                autocorrect: true,
                enableSuggestions: true,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular',
                    style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const PlacesGrid()));
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color.fromRGBO(45, 87, 124, 1),
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> const SampleDestination()));
                      },
                      child: Container(
                        width: 157,
                        height: 144,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/157x144"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended',
                    style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      color: Color.fromRGBO(45, 87, 124, 1),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favourites',
                    style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      color: Color.fromRGBO(45, 87, 124, 1),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 157,
                      height: 144,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://via.placeholder.com/157x144"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
