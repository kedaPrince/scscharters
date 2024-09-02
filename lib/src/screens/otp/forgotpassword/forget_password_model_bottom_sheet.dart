import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text.dart';
import '../../../widgets/forget_password_button_widget.dart';
import 'forget_passowrd_mail_screen.dart';


class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(iDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(iForgetPasswordTitle,
                style: Theme.of(context).textTheme.displayMedium),
            Text(iForgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30.0),
            ForgetPasswordBtnWidget(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ForgetPasswordMailScreen());
              },
              title: iEmail,
              subTitle: iResetViaEmail,
              btnIcon: Icons.mail_outline_rounded,
            ),


          ],
        ),
      ),
    );
  }
}