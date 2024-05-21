import 'dart:typed_data';

import 'package:amigos_ver1/userProfile/userOptions/galleryPhotos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UserPhotoGallery extends StatefulWidget {
  const UserPhotoGallery({Key? key}) : super(key: key);

  @override
  State<UserPhotoGallery> createState() => _UserPhotoGalleryState();
}

class _UserPhotoGalleryState extends State<UserPhotoGallery> {
  late TextEditingController _textFieldController1;
  late TextEditingController _textFieldController2;
  late DateTime _selectedDate;
  List<String> imageUrls = [];
  List<Collection> collections = [];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _textFieldController1 = TextEditingController();
    _textFieldController2 = TextEditingController();

    // Call a function to fetch and update the list of collections
    fetchCollections();
  }

  Future<void> fetchCollections() async {
    try {
      // Create a reference to the user's folder in Firebase Storage
      firebase_storage.Reference userFolderRef =
      firebase_storage.FirebaseStorage.instance.ref().child('/userSavedPictures/${user.email}/');

      // List all items (files and subdirectories) in the parent directory
      firebase_storage.ListResult result = await userFolderRef.listAll();

      // Create a list to store the fetched collections
      List<Collection> fetchedCollections = [];

      for (var item in result.items) {
        Collection folderCollection = Collection(
          name: item.name,
          location: '',
          images: [], // Initialize images as an empty list
        );

        String latestImageUrl = await getFirstImageUrl(item);

        // Append latest image URL to the images list
        folderCollection.images.add(latestImageUrl);

        fetchedCollections.add(folderCollection);
      }

      // Update the state to reflect the fetched collections
      setState(() {
        collections = fetchedCollections;
      });

      print('Collections fetched successfully');
    } catch (e) {
      print('Error fetching collections: $e');
    }
  }


  Future<String> getFirstImageUrl(firebase_storage.Reference collectionFolderRef) async {
    try {
      // List all items (files) in the collection folder
      firebase_storage.ListResult result = await collectionFolderRef.listAll();

      // Get the download URL of the first image in the folder
      String firstImageUrl = await result.items.first.getDownloadURL();

      return firstImageUrl;
    } catch (e) {
      print('Error fetching first image URL: $e');
      return ''; // Return empty string if there's an error
    }
  }

  void delCollection(String collectionName) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete collection?"),
          content: const Text(
            "Please note that this action will delete the entire collection including all the saved pictures in that collection. Do you want to proceed?",
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Create a reference to the folder
                  firebase_storage.Reference folderRef =
                  firebase_storage.FirebaseStorage.instance.ref().child(
                      'userSavedPictures/${user.email}/$collectionName');

                  await folderRef.delete();

                  print('Folder deleted successfully');

                  // Reload the screen by fetching collections again
                  fetchCollections();

                  Navigator.pop(context);
                } catch (e) {
                  print('Error deleting folder: $e');
                }
              },
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: collections.isEmpty // Check if collections list is empty
            ? _buildEmptyMessage() // Show empty message container
            : ListView.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GalleryPhotosView(collectionName: collection.name),
                  ),
                );
              },
              child: CustomCollectionTile(
                name: collection.name,
                images: collection.images,
                onDelete: delCollection,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showPopup,
        backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_very_dissatisfied_sharp,size: 20,),
          SizedBox(height: 10,),
          Text(
            'No collections saved yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _showPopup() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textFieldController1,
              decoration: const InputDecoration(labelText: 'Collection name'),
            ),
            TextField(
              controller: _textFieldController2,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromRGBO(24, 22, 106, 1),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
            ),
            onPressed: () async {
              Collection newCollection = Collection(
                name: _textFieldController1.text,
                location: _textFieldController2.text,
                images: [],
              );

              // Create a folder in Firebase Storage
              String folderName = _textFieldController1.text;
              // Create a reference to the folder path
              firebase_storage.Reference folderRef = firebase_storage
                  .FirebaseStorage.instance.ref()
                  .child('userSavedPictures/${user.email}/$folderName/');

              // Create an empty Uint8List
              Uint8List emptyData = Uint8List(0);

              // Upload an empty file to create the folder
              await folderRef.putData(emptyData);

              print('Empty folder created successfully');

              // Add the new collection to the list
              setState(() {
                collections.add(newCollection);
              });
              // Optionally, you can clear the text fields and selected date here
              _textFieldController1.clear();
              _textFieldController2.clear();
              // Close the dialog
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  @override
  void dispose() {
    _textFieldController1.dispose();
    _textFieldController2.dispose();
    super.dispose();
  }
}

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'image',
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class Collection {
  final String name;
  final List<String> images;
  final String location;

  Collection({
    required this.name,
    required this.images,
    required this.location,
  });
}


class CustomCollectionTile extends StatelessWidget {
  final String name;
  final List<String> images;
  final Function(String) onDelete;

  CustomCollectionTile({
    required this.name,
    required this.images,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onDelete(name);
                  },
                  icon: Icon(Icons.delete, color: Colors.red[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Display images in a horizontal list
            Container(
              height: 180, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  if (images[index] == '') {
                    // Show a dummy image widget when the URL is empty
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        'https://www.legrand.co.uk/modules/custom/legrand_ecat/assets/img/no-image.png',
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    // Show the network image
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        images[index],
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
