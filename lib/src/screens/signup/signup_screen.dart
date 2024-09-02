
import 'package:flutter/material.dart';
import 'package:scscharters/src/screens/signup/signup_form_widget.dart';
import '../../constants/colors.dart';
import '../../controllers/signup_controller.dart';
import '../login/login_screen.dart';
import 'package:get/get.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => initSignUp();
}

class initSignUp extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {

    return initSignUpWidget();
  }

  Widget initSignUpWidget() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset('assets/logo/splashLogoscs1.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0.0),
              alignment: Alignment.center,
              child: const Text(
                'SIGN UP',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Arial',

                  color: Colors.white,
                ),
              ),
            ),
            const SignUpFormWidget(),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account ?'),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: AppColors.yellowColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
