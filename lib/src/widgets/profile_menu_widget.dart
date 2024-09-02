import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../constants/colors.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class ProfileMenuWIdget extends StatelessWidget {

  const ProfileMenuWIdget({
    super.key, required this.title, required this.icon,this.endIcon=true, this.TextColor,
  });

  //variables to change on the widget
  final String title;
  final IconData icon;

  final bool endIcon;
  final Color? TextColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Container(
        width: AppLayout.getWidth(40),
        height: AppLayout.getHeight(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.orangeColor.withOpacity(0.1),


        ),
        child: Icon(icon, color: AppColors.yellowColor,),

      ),
      title: Text(title, style: Styles.headLineStyle3?.apply(color: AppColors.textColor),),
      trailing: endIcon? Container(
        width: AppLayout.getWidth(30),
        height: AppLayout.getHeight(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),


        ),
        child: const Icon(LineAwesomeIcons.angle_right,size: 18.0, color: AppColors.yellowColor,),

      ):null,
    );
  }
}