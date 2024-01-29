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

  Future destinationImage(){
      return showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.white.withOpacity(0.9),
          builder: (context){
            return AlertDialog(
              title: const Text("Upload destination image"),
              content: const Text("How would you like to proceed?"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: (){
                      capturePhoto;
                    },
                    child: const Text("Camera")),
                TextButton(
                    onPressed: (){
                      uploadPhoto;
                    },//,
                    child: const Text("Gallery"))
              ],
            );
          });
  }

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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0,0.0,30.0,10.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset("assets/searchbyimage.jpg",width: 1000, height: 200,)
              ),
              SizedBox(height: 30.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 50.0,
                    child: Icon(Icons.remove_red_eye,size: 50,color: Color.fromRGBO(104, 100, 247, 1)),
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
              const SizedBox(height: 35.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 50.0,
                    child: Icon(Icons.camera_alt,size: 50,color: Color.fromRGBO(104, 100, 247, 1)),
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
              const SizedBox(height: 35.0,),
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                    radius: 50.0,
                    child: Icon(Icons.attractions,size: 50,color: Color.fromRGBO(104, 100, 247, 1)),
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
                    padding: const EdgeInsets.fromLTRB(55.0,20.0,55.0,20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                    )
                  ),
                  child: const Text("UPLOAD DESTINATION IMAGE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    letterSpacing: 0.5
                  ),))
            ],
          ),
        ),
      ),
    );
  }
}
