import 'package:get/get.dart';

import '../repository/authentication_repository/authentication_repository.dart';
import '../repository/authentication_repository/user_repository/user_repository.dart';



class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  /// Step 3 get user email and pass to UserReposity to fetch user record

getUserData(){
  final email = _authRepo.firebaseUser.value?.email;
  if(email !=null) {
    return _userRepo.getUserDetails(email);

  }else {
    Get.snackbar("Error", "Login to continue");
  }

}
}