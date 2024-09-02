/*

  ====

  Todo: step1 [Create model]

  ====
 */
//second step is on user repository
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel ({
        this.id,
        required this.fullName,
        required this.email,
        required this.phoneNo,
        required this.password,
      });

  toJson(){
    return {
      "FullName" : fullName,
      "Email" : email,
      "Phone" : phoneNo,
      "Password" : password,

    };

  }
/// step 1 - fetch user data from firebase to UserModel
  factory UserModel.fromSnapshot (DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        email: data["Email"],
        fullName: data["FullName"],
        password: data["Password"],
        phoneNo: data["Phone"],

    );
}
}

