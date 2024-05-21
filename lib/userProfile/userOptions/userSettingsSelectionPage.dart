import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../authentication/traveller_authentication/pageDecider.dart';
import '../../authentication/traveller_authentication/userDeleteAccountPage.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  final user = FirebaseAuth.instance.currentUser!;

  //signOut
  Future signOut() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.9),
        builder: (context){
          return AlertDialog(
            title: const Text("Log out?"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                  onPressed: ()=> Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context)=> Decider()));
                    Fluttertoast.showToast(
                        msg: "${user.email} logged out successfully",
                        fontSize: 18,
                        timeInSecForIosWeb: 5);
                  },
                  child: const Text("Logout"))
            ],
          );
        });
  }

  //Delete account
  void delAccount(){
    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context)=> const UserDelAccount()));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(214, 217, 244, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: signOut,
              child:  Text("Log Out",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                  padding: const EdgeInsets.fromLTRB(105.0, 15.0, 105.0, 15.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )
              ),
            ),
            SizedBox(height: 10.0,),
            ElevatedButton(
              onPressed: delAccount,
              child: Text("Delete Account",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(24, 22, 106, 1),
                  padding: const EdgeInsets.fromLTRB(105.0, 15.0, 105.0, 15.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
