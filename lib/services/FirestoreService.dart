// ignore_for_file: file_names, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('userInfo');

  Future<void> createUserData(
      String firstname, String secondname, String email, String uid) async {
    return await users.doc(uid).set({
      'first name': firstname,
      'second name': secondname,
      'email': email,
    });
  }
}
