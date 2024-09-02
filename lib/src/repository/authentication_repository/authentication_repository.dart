
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../screens/home/bus_main_page.dart';
import '../../screens/login/login_screen.dart';
import 'exceptions/login_email_password_failure.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;  //this user contains the state of a user so it needs to be private hence Rx<User?>
  var verificationId = ''.obs;

  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    //firebaseUser = Rx<User?>(_auth.currentUser ?? null);
    firebaseUser.bindStream(_auth.userChanges()); //bind stream means firebase user is always listening if they are any changes by the user
    ever(firebaseUser, _setInitialScreen); //always ready to perform actions

  }


/// If we are setting initial screen from here
/// then in the main.dart => App() add CircularProgressIndicator()
  _setInitialScreen(User? user) {
    if (user == null) {
      // If user is not logged in, show the LoginScreen
      Get.offAll(() => const LoginScreen());
    } else {
      // If user is logged in, show the BusBookingMainPage
      Get.offAll(() => BusBookingMainPage());
    }
  }


  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resentToken){
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId.value = verificationId;
        },
        verificationFailed: (e){
          if(e.code =='invalid-phone-number'){
            Get.snackbar('Error', 'The phone number is not valid');
          }else {
            Get.snackbar('Error', 'Something went wrong. Try again');
          }
        }
    );
  }
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp));
    return credentials.user != null ? true : false;
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => BusBookingMainPage()) : Get.to(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) {
        print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      }
      throw ex;
     // return ex.message;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      if (kDebugMode) {
        print('EXCEPTION - ${ex.message}');
      }
      throw ex;
     // return ex.message;
    }

  }


  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User with this email does not exist. Please sign up.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password. Please try again.';
      } else {
        // Handle other authentication errors
        final ex = LogInWithEmailAndPasswordFailure.fromCode(e.code);
        return ex.message;
      }
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }




  Future<void> logout() async => await _auth.signOut();

}