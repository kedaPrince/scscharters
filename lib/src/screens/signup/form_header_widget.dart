import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    this.imageColor,
    this.heightBetween,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageHeight = 0.2,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  //Variables -- Declared in Constructor
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image), color: imageColor,),
        SizedBox(height: heightBetween),
        Text(title, style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.iSecondaryColor,)),
        Text(subTitle, textAlign: textAlign, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),),
      ],
    );
  }
}
