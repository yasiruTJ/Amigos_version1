import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPhotosView extends StatefulWidget {
  const GalleryPhotosView({Key? key, required this.collectionName}) : super(key: key);
  final String collectionName;

  @override
  State<GalleryPhotosView> createState() => _GalleryPhotosViewState();
}

class _GalleryPhotosViewState extends State<GalleryPhotosView> {
  List<String> imageUrls = [];
  List<File> selectedImages = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Call the method to fetch saved images when the widget initializes
    fetchSavedImages();
  }

  Future<void> fetchSavedImages() async {
    try {
      // Get a reference to the Firebase Storage bucket
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // Create a reference to the folder where the images are stored
      final firebase_storage.Reference imagesFolderRef =
      storage.ref().child(
          'userSavedPictures/${user?.email}/${widget.collectionName}/');

      // List all items (files) in the folder
      final ListResult result = await imagesFolderRef.listAll();

      // Iterate over the items and get the download URL for each image
      for (var imageRef in result.items) {
        final String downloadURL = await imageRef.getDownloadURL();
        setState(() {
          imageUrls.add(downloadURL);
        });
      }

    } catch (e) {
      print('Error fetching saved images: $e');
    }
  }

  Future<void> getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
      // Upload selected images to Firebase Storage
      await uploadImages(selectedImages);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images selected')),
      );
    }
  }

  Future<void> uploadImages(List<File> images) async {
    try {
      // Get a reference to the Firebase Storage bucket
      final firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      // Create a reference to the location you want to upload to
      final firebase_storage.Reference folderRef = storage.ref().child(
          'userSavedPictures/${user?.email}/${widget.collectionName}/');

      for (var imageFile in images) {
        // Create a reference to the image file
        final firebase_storage.Reference imageRef = folderRef.child(
            '${DateTime.now().millisecondsSinceEpoch}.png');

        // Upload the file to Firebase Storage
        await imageRef.putFile(imageFile,
            firebase_storage.SettableMetadata(contentType: 'image/png'));

        // Get the download URL for the file
        final String downloadURL = await imageRef.getDownloadURL();

        // Add the download URL to the list
        setState(() {
          imageUrls.add(downloadURL);
        });
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
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
        title:  Text(
          widget.collectionName,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: imageUrls.isEmpty && selectedImages.isEmpty
          ? const Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_very_dissatisfied_sharp,size: 30,),
            SizedBox(height: 10,),
            Text(
              'No Images have been saved yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          :GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        itemCount: selectedImages.length + imageUrls.length,
        itemBuilder: (context, index) {
          if (index < selectedImages.length) {
            // Display selected images
            return GestureDetector(
              onTap: () {
                // Handle onTap for selected image
              },
              child: Image.file(
                selectedImages[index],
                fit: BoxFit.cover,
              ),
            );
          } else {
            // Display saved images from Firebase Storage
            final savedImageIndex = index - selectedImages.length;
            return GestureDetector(
              onTap: () {
                // todo
              },
              child:
              Image.network(
                imageUrls[savedImageIndex],
                fit: BoxFit.cover,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getImages();
        } ,
        backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
        child: const Icon(Icons.add_photo_alternate_rounded),
      ),
    );
  }
}
