
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import 'package:get/get.dart';

import '../../constants/text.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/app_layout.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi!',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 5),
            FutureBuilder(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;
                    return Column(
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("Something went wrong"));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: CircleAvatar(
              backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
              radius: 16,
              child: const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
            ),

        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: Row(
              children: [
                Text('Information Desk', style: TextStyle(color: Colors.black)),


              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                // Add your background image or color here
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset('assets/logo/infoLogo.png'),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      heading1,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(12)),
                    const Text(
                      heading1Text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const Text(
                      heading2,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(12)),
                    const Text(
                      heading2Text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const Text(
                      heading3,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(12)),
                    const Text(
                      heading3Text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const Text(
                      heading4,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    Gap(AppLayout.getHeight(12)),
                    const Text(
                      heading4Text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
