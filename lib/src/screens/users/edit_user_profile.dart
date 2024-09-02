import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../constants/image_string.dart';
import '../../constants/sizes.dart';
import '../../constants/text.dart';
import '../../controllers/profile_controller.dart';
import '../../repository/authentication_repository/user_repository/user_repository.dart';
import '../../utils/app_layout.dart';
import '../signup/signup_screen.dart';

class EditUserProfileScreen extends StatefulWidget {
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final controller = Get.put(ProfileController());
  UserModel? user;
  final UserRepository _userRepo = UserRepository();
  String updatedFullName = '';
  String updatedEmail = '';
  String updatedPhoneNo = '';
  String updatedPassword = '';
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final userData = await controller.getUserData();
    if (mounted) {
      setState(() {
        user = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff171921),
      appBar: AppBar(
        backgroundColor: const Color(0xff171921),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
          color: AppColors.yellowColor,
        ),
        title: Text(
          iProfile,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(iDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (user != null) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(image: AssetImage(iProfileImage)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.yellowColor,
                            ),
                            child: const Icon(LineAwesomeIcons.camera, size: 18.0, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.fullName ?? '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      child: Column(
                        children: [
                          Gap(AppLayout.getHeight(20)),
                          TextFormField(
                            initialValue: updatedFullName.isNotEmpty ? updatedFullName : user?.fullName ?? '',
                            onChanged: (value) {
                              updatedFullName = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              label: Text(iFullName, style: TextStyle(color: Colors.white)),
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.yellowColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white),
                              ),
                            ),
                          ),
                          Gap(AppLayout.getHeight(20)),
                          TextFormField(
                            initialValue: updatedEmail.isNotEmpty ? updatedEmail : user?.email ?? '',
                            onChanged: (value) {
                              updatedEmail = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              label: Text(iEmail, style: TextStyle(color: Colors.white)),
                              prefixIcon: Icon(Icons.email_outlined, color: AppColors.yellowColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white),
                              ),
                            ),
                          ),
                          Gap(AppLayout.getHeight(20)),
                          TextFormField(
                            initialValue: updatedPhoneNo.isNotEmpty?updatedPhoneNo:user?.phoneNo ?? '',
                            onChanged: (value) {
                              // Update the updatedFullName variable when the form field value changes
                              updatedPhoneNo = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              label: Text(iPhoneNo, style: TextStyle(color: Colors.white)),
                              prefixIcon: Icon(Icons.numbers, color: AppColors.yellowColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white),
                              ),
                            ),
                          ),
                          Gap(AppLayout.getHeight(20)),
                          TextFormField(
                            initialValue: updatedPassword.isNotEmpty?updatedPassword:user?.password ?? '',
                            onChanged: (value) {
                              // Update the updatedFullName variable when the form field value changes
                              updatedPassword = value;
                            },
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text(iPassword, style: TextStyle(color: Colors.white)),
                              prefixIcon: Icon(Icons.fingerprint, color: AppColors.yellowColor),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.amberAccent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 3, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                // Define a function to save the edits to Firebase
                                void saveProfile() async {
                                  // Create a new UserModel with the updated data
                                  UserModel updatedUser = UserModel(
                                    id: user?.id,
                                    fullName: updatedFullName.isNotEmpty ? updatedFullName : user!.fullName,
                                    email: updatedEmail.isNotEmpty ? updatedEmail : user!.email,
                                    phoneNo: updatedPhoneNo.isNotEmpty ? updatedPhoneNo : user!.phoneNo,
                                    password: updatedPassword.isNotEmpty ? updatedPassword : user!.password,
                                  );

                                  // Call the UserRepository's updateUser method to save the updated user data
                                  await _userRepo.updateUser(updatedUser);

                                  // Show a success message
                                  Get.snackbar("Success", "Profile Updated",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green.withOpacity(0.1),
                                    colorText: Colors.green,
                                  );
                                }



                                // Call the saveProfile function when the "Save Profile" button is clicked
                                saveProfile();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFeb9f49), Color(0xFF262624)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  iEditProfile,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          ),
                          const SizedBox(height: iDefaultSize),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Show a confirmation dialog before deleting the account
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Account Deletion"),
                                      content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // Delete the account if confirmed
                                if (confirmed == true) {
                                  await _userRepo.deleteUser(user?.id);
                                  // Navigate back to the SignUpScreen
                                  Get.offAll(const SignUpScreen());
                                }
                              },
                              child: const Text("Delete Account", style: TextStyle(color: Colors.red)),
                            ),

                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },


          ),
        ),

      ),
    );
  }
}
