import 'package:flutter/material.dart';
import 'package:scscharters/src/screens/otp/forgotpassword/forget_password_model_bottom_sheet.dart';
import '../../constants/colors.dart';
import '../../controllers/login_controller.dart';
import '../signup/signup_screen.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(loginController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return initState();
  }


  Widget initState(){
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                //color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Image.asset('assets/logo/splashLogoscs1.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 40, right: 40, top: 0),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],

                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        //key: const Key('email_field'),
                        controller: controller.email,
                        cursorColor: AppColors.yellowColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.mail,
                            color: AppColors.darkColor,
                          ),
                          hintText: 'Enter Email',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 40, right: 40, top: 30),
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],

                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                       // key: const Key('password_field'),
                        controller: controller.password,
                        obscureText: true,
                        cursorColor: AppColors.darkColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: AppColors.darkColor,
                          ),
                          hintText: 'Enter Password',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),


                    GestureDetector(

                      onTap: () {
                        if(_formKey.currentState!.validate()){
                          //call signUp controller with the registration method
                          loginController.instance.loginUser(controller.email.text.trim(), controller.password.text.trim());

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
                          child:const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),

                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, right: 45),
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('Forgot Password',style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                ),),
                onPressed: () =>{
              ForgetPasswordScreen.buildShowModalBottomSheet(context),

                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don"t have an account ?'),
                  GestureDetector(
                    onTap: () =>{

                      Navigator.push(context, MaterialPageRoute(
                        builder:(context) =>  const SignUpScreen(),
                      ),
                      ),

                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.yellowColor,
                        fontSize: 16,
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
