import 'package:flutter/material.dart';

class DottedLineLayout extends StatelessWidget {
  final bool? isColor;
  final int sections;
  final double width;
  const DottedLineLayout({super.key, this.isColor, required this.sections,  this.width=3});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(

      builder: (BuildContext  context, BoxConstraints constraints) {


        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: List.generate((constraints.constrainWidth()/sections).floor(), (index) =>
              SizedBox(width: 5, height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isColor==null? Colors.black54:Colors.grey.shade300,
                  ),
                ),
              ),
          ),
        );
      },

    );
  }
}
