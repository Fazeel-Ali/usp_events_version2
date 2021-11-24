// ignore_for_file: prefer_const_constructors, unnecessary_this, file_names, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usp_events_version2/model/user_model.dart';
import 'package:usp_events_version2/services/FirestoreService.dart';
import 'package:usp_events_version2/view/login.dart';
import 'package:usp_events_version2/widgets/loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _secondnameController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String userID = "";
  // loading
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchUserData();
  }

  fetchUserInfo() async {
    User getUser = await FirebaseAuth.instance.currentUser!;
    userID = getUser.uid;
  }

//fetching user data from firestore
  fetchUserData() async {
    await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  updateData(String firstname, String secondname, String userID) async {
    await DatabaseManager().updateUserData(firstname, secondname, userID);
    fetchUserData();
  }

// Profile UI
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(30.0),
                child: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    openDialogueBox(context);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  color: Colors.teal,
                ),
                MaterialButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  color: Colors.teal,
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 145,
                        child: Image.asset("assets/profile.jpg",
                            fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${loggedInUser.firstname} ${loggedInUser.secondname}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${loggedInUser.email}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  //Dialogue Box Function
  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit User Details'),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: _firstnameController,
                    decoration: InputDecoration(hintText: ' First Name'),
                  ),
                  TextField(
                    controller: _secondnameController,
                    decoration: InputDecoration(hintText: 'Second Name'),
                  ),
                ],
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  submitAction(context);
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    setState(() => loading = true);
    updateData(_firstnameController.text, _secondnameController.text, userID);

    _firstnameController.clear();
    _secondnameController.clear();
    setState(() => loading = false);
  }
}
