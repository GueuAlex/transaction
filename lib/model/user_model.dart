import 'dart:ffi';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  //String? depenses;

  UserModel({this.uid, this.email, this.firstName, this.lastName});

  //receiving from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        //depenses: map['depenses'],
        lastName: map['lastName']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return ({
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName
    });
  }
}
