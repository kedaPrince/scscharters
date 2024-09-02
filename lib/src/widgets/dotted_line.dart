import 'package:flutter/material.dart';


class DottedLineWidget extends StatefulWidget {
  const DottedLineWidget({super.key});

  @override
  State<DottedLineWidget> createState() => _DottedLineWidgetState();
}

class _DottedLineWidgetState extends State<DottedLineWidget> {
  @override
  Widget build(BuildContext context) {
    return   Padding(
        padding: const EdgeInsets.all(1.0),
        child: LayoutBuilder(//horizonal lines
          builder: (BuildContext context, BoxConstraints constraints) {
            return Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(
                (constraints.constrainWidth() / 5).floor(),
                    (index) => const SizedBox(
                  width: 4,
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color:Colors.black54,
                    ),
                  ),
                ),
              ),
            );
          },
        ),


    );
  }
}
