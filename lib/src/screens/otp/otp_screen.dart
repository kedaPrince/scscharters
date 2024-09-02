import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/sizes.dart';
import '../../constants/text.dart';
import '../../controllers/otp_controller.dart';


class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var otpController = Get.put(OTPController());
    var otp;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(iDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              iOtpTitle,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(iOtpSubTitle.toUpperCase(), style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 40.0),
            const Text("$iOtpMessage support@shoesmith-bus.co.za", textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (code) {
                  otp = code;
                  OTPController.instance.verifyOTP(otp);

                }),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                OTPController.instance.verifyOTP(otp);
              }, child: const Text(iNext)),
            ),
          ],
        ),
      ),
    );
  }
}