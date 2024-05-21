import 'package:amigos_ver1/authentication/guide_authentication/guidePageDecider.dart';
import 'package:amigos_ver1/authentication/traveller_authentication/pageDecider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTypeSelector extends StatefulWidget {
  const UserTypeSelector({Key? key}) : super(key: key);

  @override
  State<UserTypeSelector> createState() => _UserTypeSelectorState();
}

void travellerPage(BuildContext context) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const Decider()));
}

void guidePage(BuildContext context) {
  Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => const GuidePageDecider()));
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0.0, screenWidth * 0.08, screenHeight * 0.08),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/amigos_logo.png", width: 150, height: 150,),
                  const Text("WELCOME TO AMIGOS",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(9, 25, 81, 1),
                    ),),
                  const SizedBox(height: 40.0,),
                  const Text("Select your user type",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(9, 25, 81, 1),
                    ),),
                  const SizedBox(height: 70.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            travellerPage(context);
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: screenWidth * 0.15,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/traveller.png', fit: BoxFit.cover,)
                              ),
                              const SizedBox(height: 15.0,),
                              const Text("Tourist",
                                style: TextStyle(
                                  color: Color.fromRGBO(24, 22, 106, 1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                ),)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            guidePage(context);
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: screenWidth * 0.15,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/guide.png', fit: BoxFit.cover,)
                              ),
                              const SizedBox(height: 15.0,),
                              const Text("Tour Guide",
                                style: TextStyle(
                                    color: Color.fromRGBO(24, 22, 106, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0
                                ),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
