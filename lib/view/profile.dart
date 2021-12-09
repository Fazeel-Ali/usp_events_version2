// ignore_for_file: prefer_const_constructors, unnecessary_this, file_names, avoid_print, await_only_futures, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

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
  final TextEditingController _aboutController = TextEditingController();

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

  updateData(
      String firstname, String secondname, String about, String userID) async {
    await DatabaseManager()
        .updateUserData(firstname, secondname, about, userID);
    fetchUserData();
  }

// Profile UI
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {},
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
            body: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: HeaderCurvedContainer(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 1.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images.png'),
                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 38),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${loggedInUser.about}",
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
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
            content: SingleChildScrollView(
              child: SizedBox(
                height: 350,
                child: Column(
                  children: [
                    TextField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          hintText: 'Enter you first name'),
                    ),
                    TextField(
                      controller: _secondnameController,
                      decoration: InputDecoration(
                          labelText: 'Second Name',
                          hintText: 'Enter you last name'),
                    ),
                    TextField(
                      controller: _aboutController,
                      decoration: InputDecoration(
                          labelText: 'About', hintText: 'Write about yourself'),
                      maxLines: 4,
                    ),
                  ],
                ),
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
    updateData(_firstnameController.text, _secondnameController.text,
        _aboutController.text, userID);

    _firstnameController.clear();
    _secondnameController.clear();
    _aboutController.clear();
    setState(() => loading = false);
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.teal;
    Path path = Path()
      ..relativeLineTo(0, 130)
      ..quadraticBezierTo(size.width / 3, 195, size.width, 130)
      ..relativeLineTo(0, -130)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
