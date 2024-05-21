import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:amigos_ver1/location_Identifier_Results/sampleResultTabs.dart';
import 'package:amigos_ver1/placeFinder/locationHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../services/map_services.dart';

class ImageCollector extends StatefulWidget {
  const ImageCollector({Key? key}) : super(key: key);

  @override
  State<ImageCollector> createState() => _ImageCollectorState();
}

final user = FirebaseAuth.instance.currentUser!;

class ResultData {
  final String predictedClass;
  final double accuracy;

  ResultData({
    required this.predictedClass,
    required this.accuracy,
  });
}
String url = "";

class _ImageCollectorState extends State<ImageCollector> {
  String? message = "";
  File? _imageFile;
  GlobalKey _key = GlobalKey();

  bool isLoading = false;

  Future<ResultData?> destinationImage() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_imageFile != null) {
        Uint8List imageData = await _captureImageWithoutUI(_key);
        String base64Image = base64Encode(imageData);
        Map<String, String> body = {'image': base64Image};

        final response = await http.post(
          Uri.parse('http://10.0.2.2:5000/upload-image'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          url = await uploadImage(_imageFile!);
          final responseData = json.decode(response.body);
          ResultData resultData = ResultData(
            predictedClass: responseData['predicted_class'],
            accuracy: responseData['accuracy'].toDouble(),
          );
          print('Image uploaded successfully!');
          Navigator.pop(context); // Close the dialog
          return resultData;
        } else {
          print('Error uploading image: ${response.statusCode}');
          throw Exception('Error uploading image: ${response.statusCode}');
        }
      } else {
        print('No image selected');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Image identification failed"),
              content: const Text("Please make sure that you have uploaded an image!"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred while uploading the image: $e"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return null;
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false regardless of the result
      });
    }
  }


  Future<Uint8List> _captureImageWithoutUI(GlobalKey key) async {
    RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }


  Future<String> uploadImage(File imageFile) async {
    try {
      print(user.email);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('destinationImages/${user.email}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Future<void> capturePhotoGallery() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    final imageTemp = File(imageFile!.path);

    setState(() {
      _imageFile = imageTemp;
    });
  }

  Future<void> capturePhotoCamera() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
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
        title: const Text(
          "DESTINATION FINDER",
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: RepaintBoundary(
                  key: _key,
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : Image.asset("assets/noImage.png"),
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: capturePhotoCamera,
                    child: const Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                          radius: 30,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Color.fromRGBO(104, 100, 247, 1),
                            size: 25.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Camera",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                          radius: 30,
                          child: Icon(
                            Icons.photo_size_select_actual_outlined,
                            color: Color.fromRGBO(104, 100, 247, 1),
                            size: 25.0,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: Color.fromRGBO(24, 22, 106, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ResultData? result = await destinationImage();
                      if (result != null) {
                        String? imageUrl = url;
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SampleResultTabs(destinationResult: result.predictedClass ?? '', imageUrl: imageUrl ?? ''),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4, // Adjust the width as needed
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: const Text(
                        "IDENTIFY LOCATION",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                      CupertinoPageRoute(builder: (context)=>const History()));
                    },
                    child: const CircleAvatar(
                      backgroundColor: Color.fromRGBO(202, 201, 255, 1),
                      radius: 30,
                      child: Icon(
                        Icons.history_outlined,
                        color: Color.fromRGBO(104, 100, 247, 1),
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(24, 22, 106, 1),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

