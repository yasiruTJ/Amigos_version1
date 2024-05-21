import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

final user = FirebaseAuth.instance.currentUser!;

class _HistoryState extends State<History> {

  List<String> imageUrls = []; // List to store image URLs

  @override
  void initState() {
    super.initState();
    fetchImageUrls(); // Fetch image URLs when the page initializes
  }

  Future<void> fetchImageUrls() async {
    print(user.email);
    final ListResult result = await FirebaseStorage.instance.ref('destinationImages/${user.email}/').listAll();
    final List<String> urls = await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
    setState(() {
      imageUrls = urls;
      print(imageUrls);
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
        title: const Text("LOCATION HISTORY",style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0
        )),
      ),
      body: imageUrls.isEmpty
          ?  const Center(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(24, 22, 106, 1)),
                  strokeWidth: 3.0,
                ),
                SizedBox(height: 15.0,),
                Text("Retrieving search history...",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 22, 106, 1),
                      fontSize: 15.0
                  ),),
              ],
            ),
          )
          : ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0), // Adjust the spacing as needed
            child: Image.network(
              imageUrls[index],
              width: 300,
              height: 300,
            ),
          );
        },
      ),
    );
  }
}
