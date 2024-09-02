import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../repository/authentication_repository/authentication_repository.dart';
import '../screens/login/login_screen.dart';


class loginController extends GetxController {
  static loginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty) {
      Get.snackbar(
        'Login Error',
        'Please enter an email to log in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red, // Set the background color to red
      );
      return;
    }

    String? error =
    await AuthenticationRepository.instance.loginWithEmailAndPassword(email, password);

    if (error != null) {
      Get.snackbar(
        'Login Error',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red, // Set the background color to red
      );
    }
  }


  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Password Reset',
        'A password reset email has been sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );

      // Navigate back to the login screen
      Get.off(() => LoginScreen());
    } catch (e) {
      print('Password Reset Error: $e'); // Add this line to print the error details
      Get.snackbar(
        'Password Reset Error',
        'Failed to send password reset email. Please check the email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

}

