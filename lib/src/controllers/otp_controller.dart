
import 'package:get/get.dart';

import '../repository/authentication_repository/authentication_repository.dart';
import '../screens/home/home.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll( const HomePage()) : Get.back();
  }


}