class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? secondname;

  UserModel({this.uid, this.email, this.firstname, this.secondname});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstname: map['first name'],
      secondname: map['second name'],
    );
  }
}
