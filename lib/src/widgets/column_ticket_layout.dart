import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/app_layout.dart';


class TicketColumnLayout extends StatelessWidget {
  final String firstText;
  final String secondText;
  final bool? isColor;
  final CrossAxisAlignment alignment;
  const TicketColumnLayout({super.key, required this.firstText, required this.secondText, required this.alignment, this.isColor});

  @override
  Widget build(BuildContext context) {
    return   Column(
      crossAxisAlignment: alignment,
      children: [
        Text(firstText,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 16),),

        Gap(AppLayout.getHeight(5)),
        Text(secondText, style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 16),),
      ],
    );
  }
}
