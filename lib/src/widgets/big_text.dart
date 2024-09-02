import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

//purpose of this is to reuse the font and text color


class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  final FontWeight? fontWeight;

  BigText({super.key, this.color =const Color(0xFF332d2b),
    required this.text,
    this.overFlow = TextOverflow.ellipsis,
    this.size=0,
    this.fontWeight,
  });


  @override
  Widget build(BuildContext context) {
    return Text(
      text, //text we going to pass, same as color
      overflow: overFlow,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize:  size==0?Dimensions.font20:size,
        fontWeight: fontWeight,
      ),
    );
  }
}
