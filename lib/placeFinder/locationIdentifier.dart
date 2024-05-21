import 'dart:io';

import 'package:amigos_ver1/placeFinder/imageCollector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LocationIdentifier extends StatefulWidget {
  const LocationIdentifier({super.key});

  @override
  State<LocationIdentifier> createState() => _LocationIdentifierState();
}

class _LocationIdentifierState extends State<LocationIdentifier> {

  File? _imageFile;

  //upload photo from gallery
  Future uploadPhoto() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text("Please add an image!"));
          });
    } else {
      final imageTemp = File(imageFile!.path);

      setState(() async {
        _imageFile = imageTemp;
      });
    }
  }

  //upload photo from camera
  Future capturePhoto() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (imageFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(title: Text("Please add an image!"));
          });
    } else {
      final imageTemp = File(imageFile!.path);

      setState(() async {
        _imageFile = imageTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 0.0, screenWidth * 0.08, screenHeight * 0.01),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset("assets/searchbyimage.jpg",width: 1000, height: 200,)
              ),
              SizedBox(height: 20.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 40.0,
                    child: Icon(Icons.remove_red_eye,size: 30,color: Color.fromRGBO(104, 100, 247, 1)),
                  ),
                  SizedBox(width: 15.0,),
                  Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. See it, Search it",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),),
                        SizedBox(height: 10.0,),
                        Text("Did you see somewhere you would love to \ngo but don’t know where it is?",
                          style: TextStyle(
                            color: Color.fromRGBO(45, 87, 124, 1),
                            fontSize: 11.0,
                          ),)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 40.0,
                    child: Icon(Icons.camera_alt,size: 30,color: Color.fromRGBO(104, 100, 247, 1)),
                  ),
                  SizedBox(width: 15.0,),
                  Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2. Upload destination image",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),),
                        SizedBox(height: 10.0,),
                        Text("Upload an image of your desired destination.",
                          style: TextStyle(
                            color: Color.fromRGBO(45, 87, 124, 1),
                            fontSize: 11.0,
                          ),)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 40.0,
                    child: Icon(Icons.attractions,size: 30,color: Color.fromRGBO(104, 100, 247, 1)),
                  ),
                  SizedBox(width: 15.0,),
                  Align(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("3. Find details",
                        style: TextStyle(
                          color: Color.fromRGBO(24, 22, 106, 1),
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                        ),),
                        SizedBox(height: 10.0,),
                        Text("We will find you what the location is and all \ninformation related to that place.",
                        style: TextStyle(
                          color: Color.fromRGBO(45, 87, 124, 1),
                          fontSize: 11.0,
                        ),)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30.0,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, CupertinoPageRoute
                      (builder: (context)=> const ImageCollector()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                    )
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust the width as needed
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: const Text("UPLOAD DESTINATION IMAGE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
