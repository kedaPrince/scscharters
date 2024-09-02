import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/user_model.dart';


/*
========
Todo : Step -2 [user repository to perform db operations]
========

 */

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  //point to the root of our db

  final _db = FirebaseFirestore.instance;

//create user method that will have data from the UserModel
  //the functions gets values we want to store in db from UserModel

  createUser(UserModel user) async {

    //point to the db we want to store the data and call the collection we want to save data to
    //we will add data
//so call everything mapped to the json we created in UserModel
    await _db.collection("users").add(user.toJson()).whenComplete(() {
      Get.snackbar("Successful", "Your Account has been created",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }).catchError((error, Stacktrace){
      Get.snackbar("Error", "Something went wrong, Try Again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,);
      if (kDebugMode) {
        print("ERROR - $error");
      }

    });

  }

  /// step 2 - fetch all users / user details

  Future<UserModel> getUserDetails (String email) async {
    final snapshot = await _db.collection("users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
  /// here we can show all users for admin without any email
  Future<List<UserModel>> allUsers () async {
    final snapshot = await _db.collection("users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      // Get the document reference for the user by ID
      final userDoc = _db.collection("users").doc(user.id);

      // Update the user data in Firebase
      await userDoc.update(user.toJson());

      Get.snackbar("Success", "Profile Updated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (error) {
      Get.snackbar("Error", "Failed to update profile: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> deleteUser(String? userId) async {
    if (userId != null) {
      // Delete the user document in Firestore
      await _db.collection("users").doc(userId).delete();
      // You might also want to sign out the user
      // ...
    }
  }

}