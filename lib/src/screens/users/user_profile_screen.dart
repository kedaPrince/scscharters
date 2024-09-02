import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../controllers/profile_controller.dart';
import '../../repository/authentication_repository/authentication_repository.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../../widgets/profile_menu_widget.dart';
import 'edit_user_profile.dart';


class userProfileScreen extends StatefulWidget {
  const userProfileScreen({Key? key}) : super(key: key);

  @override
  State<userProfileScreen> createState() => _userProfileScreenState();
}

class _userProfileScreenState extends State<userProfileScreen> {


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    var isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    return Container(
      color: Color(0xff171921),
      child: Scaffold(
        backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
        appBar: AppBar(

          title: Text('Profile', style: Styles.headLineStyle5,),
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          foregroundColor: Colors.orange,

        ),
        body: SingleChildScrollView(
          child: Container(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 80, height: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset("assets/images/profile.jpg")),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: AppLayout.getWidth(35),
                          height: AppLayout.getHeight(35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xffFF7029),


                          ),
                          child: const Icon(LineAwesomeIcons.alternate_pencil,size: 20.0, color: Colors.black,),

                        ),
                      ),
                    ],
                  ),
                  Gap(AppLayout.getHeight(20)),
                  Container(
                   child: Column(
                     children: [
                       FutureBuilder(
                           future: controller.getUserData(),
                         builder:(context,snapshot){
                             if(snapshot.connectionState==ConnectionState.done){
                               if(snapshot.hasData){
                                 UserModel user = snapshot.data as UserModel;
                                 return Column(
                                   children: [
                                     Text(user.fullName, style: Styles.headLineStyle2,),
                                     Text(user.email, style: Styles.headLineStyle3,),
                                   ],
                                 );
                               }else if(snapshot.hasError){
                                 return Center(child: Text(snapshot.error.toString()),);
                               }else{
                                 return const Center(child: Text("Something went wrong"),);
                               }
                             }else{
                               return Center(child: CircularProgressIndicator());
                             }
                         }
                       ),
                     ],
                   ),
                  ),
                  Gap(AppLayout.getHeight(10)),
                  GestureDetector(
                    onTap: ()=>Get.to(()=>EditUserProfileScreen()),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),

                      ),

                    ),

                  ),
                  Gap(AppLayout.getHeight(10)),
                  const Divider(color: Colors.white,),
                  Gap(AppLayout.getHeight(10)),
                   const ProfileMenuWIdget(title: 'Settings', icon: LineAwesomeIcons.cog,),
                  const ProfileMenuWIdget(title: 'Billing Details', icon: LineAwesomeIcons.wallet,),
                  const ProfileMenuWIdget(title: 'Tickets', icon: LineAwesomeIcons.alternate_ticket,),
                  const Divider(color: Colors.white,),
                  Gap(AppLayout.getHeight(10)),
                  const ProfileMenuWIdget(title: 'Information', icon: LineAwesomeIcons.info,),
                  GestureDetector(
                    onTap: () =>AuthenticationRepository.instance.logout(),
                    child: const ProfileMenuWIdget(
                      title: 'Logout',
                      icon: LineAwesomeIcons.alternate_sign_out,
                      TextColor:Colors.red,
                      endIcon: false,
                    ),
                  ),
                ],
              ),

            ),

          ),

        ),

      ),
    );
  }
}
