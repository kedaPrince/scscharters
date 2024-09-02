import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/image_string.dart';
import '../../constants/text.dart';
import 'package:get/get.dart';


import '../login/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("OR", style: TextStyle(color: Colors.white),),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const SizedBox(
          width: double.infinity,
          child: Image(
              image: AssetImage(iGoogleLogoImage),
              width: 20.0,
            ),

            ),



        TextButton(
          onPressed: () =>Get.to(() =>const LoginScreen()),
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: iAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green),
            ),
            TextSpan(text: iLogin.toUpperCase(),style: const TextStyle(color: AppColors.iSecondaryColor))
          ])),
        )
      ],
    );
  }
}