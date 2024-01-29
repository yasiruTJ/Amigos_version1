import 'dart:io';

import 'package:amigos_ver1/placeFinder/sampleResult.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCollector extends StatefulWidget {
  const ImageCollector({super.key});

  @override
  State<ImageCollector> createState() => _ImageCollectorState();
}

class _ImageCollectorState extends State<ImageCollector> {

  void destinationImage(){
    if (_imageFile != null){
      //temp (either the image will hv to get stored in firebase or locally. RESEARCH)
      Navigator.push(context, CupertinoPageRoute(builder: (context)=> const SampleResult()));
    }
    else{
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Please provide an image of a place to proceed!", textAlign: TextAlign.center,),
            );
          });
    }

  }

  File? _imageFile;

  //upload photo from gallery
  Future capturePhotoGallery() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
      final imageTemp = File(imageFile!.path);

      setState(() {
        _imageFile = imageTemp;
      });
  }

  //upload photo from camera
  Future capturePhotoCamera() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
      final imageTemp = File(imageFile!.path);

      setState(() {
        _imageFile = imageTemp;
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
        title: const Text("DESTINATION FINDER",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                width: 450,
                height: 450,
                child: _imageFile != null ? Image.file(_imageFile!) : Image.asset("assets/noImage.png"),
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: capturePhotoCamera,
                    child: const Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 40,
                          child: Icon(Icons.camera_alt_outlined,color: Color.fromRGBO(104, 100, 247, 1),size: 35.0,),
                        ),
                        SizedBox(height: 10.0,),
                        Text("Camera",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w400,
                          ),)
                      ],
                    ),
                  ),
                  const SizedBox(width: 65.0),
                  GestureDetector(
                    onTap: capturePhotoGallery,
                    child: const Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 40,
                          child: Icon(Icons.photo_size_select_actual_outlined,color: Color.fromRGBO(104, 100, 247, 1),size: 35.0,),
                        ),
                        SizedBox(height: 10.0,),
                        Text("Gallery",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w400,
                          ),)
                      ],
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 50.0,),
              ElevatedButton(
                  onPressed: destinationImage,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                      padding: const EdgeInsets.fromLTRB(55.0,20.0,55.0,20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      )
                  ),
                  child: const Text("PROCEED FOR IDENTIFICATION",
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
