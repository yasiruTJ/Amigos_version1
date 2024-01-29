import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/backgroundMain.jpeg"),
            fit: BoxFit.cover,
        ),
      ),
      child : const Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0,200.0,0.0,0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_location_sharp,
                      color: Color.fromRGBO(195, 234, 109, 1),
                      size: 70.0,
                    ),
                    SizedBox(width: 10.0,),
                    Text("AMIGOS",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 70.0,
                        color: Color.fromRGBO(195, 234, 109, 1),
                      ),)
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
