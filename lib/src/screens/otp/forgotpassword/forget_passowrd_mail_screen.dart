import 'package:flutter/material.dart';
import 'package:scscharters/src/controllers/login_controller.dart';
import '../../../constants/image_string.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text.dart';
import '../../signup/form_header_widget.dart';


class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    loginController controller = loginController();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding:  const EdgeInsets.all(iDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: iDefaultSize * 4),
                FormHeaderWidget(
                  image: iForgetPasswordImage,
                  title: iForgetPassword.toUpperCase(),
                  subTitle: iForgetPasswordSubTitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: iFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            label: Text(iEmail),
                            hintText: iEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [(Color(0xFFeb9f49)), (Color(0xFF262624))],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),

                          ),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  ),
                              onPressed: () {
                                loginController.instance.resetPassword(controller.email.text.trim());
                              },
                              child: const Text('Reset Password'))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}