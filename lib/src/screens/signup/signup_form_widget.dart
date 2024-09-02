import 'package:flutter/material.dart';

import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../constants/text.dart';
import 'package:get/get.dart';

import '../../controllers/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: iFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],),
              child: TextFormField(
                controller: controller.email,
                cursorColor: AppColors.yellowColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.mail, color:AppColors.darkColor,
                  ),
                  hintText: 'Enter Email',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],),
              child: TextFormField(
                controller: controller.fullName,
                cursorColor: AppColors.yellowColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person, color: AppColors.darkColor,),
                  hintText: 'Full name',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),

            const Center(
                child:Text('When you enter mobile please start with +61', style: TextStyle(color: Colors.white),)),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],),
              child: TextFormField(
                controller: controller.phoneNo,
                cursorColor: AppColors.yellowColor,
                decoration:InputDecoration(
                  icon: Icon(
                    Icons.phone, color: AppColors.darkColor,
                  ),
                  hintText: 'Mobile',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],),
              child: TextFormField(
                controller: controller.password,
                obscureText: true,
                cursorColor: AppColors.yellowColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.vpn_key, color: AppColors.darkColor,
                  ),
                  hintText: 'Password',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(_formKey.currentState!.validate()){
                  // SignUpController.instance.phoneAuthentication(controller.phoneNo.text.trim());
                  /*
                    ==========
                    Todo: Step - 3 [Get user]
                    ==========
                     */

                  final user = UserModel(
                    email: controller.email.text.trim(),
                    password: controller.password.text.trim(),
                    fullName: controller.fullName.text.trim(),
                    phoneNo: controller.phoneNo.text.trim(),

                  );
                  SignUpController.instance.createUser(user);
                  SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());


                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [(Color(0xFFeb9f49)), (Color(0xFF262624))],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:Text(iSignup.toUpperCase(), style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                ),

              ),

            ),

          ],
        ),
      ),
    );
  }
}