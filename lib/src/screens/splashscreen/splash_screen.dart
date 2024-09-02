import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

import '../login/login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<Splashscreen> {

  @override
  void initState(){
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, loginRoute);
  }

  loginRoute (){

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return initialWidget();
  }

  Widget initialWidget() {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Container(

          ),
          Center(
            child: Image.asset("assets/logo/splashLogo.png"),
          ),
        ],
      ),
    );
  }
}