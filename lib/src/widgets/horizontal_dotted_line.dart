import 'package:flutter/material.dart';

class HorizontalDottedLines extends StatefulWidget {
  const HorizontalDottedLines({super.key});

  @override
  State<HorizontalDottedLines> createState() => _HorizontalDottedLinesState();
}

class _HorizontalDottedLinesState extends State<HorizontalDottedLines> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(

      height: 10,

      child: Row(
        children: [

          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                    (constraints.constrainWidth() / 15).floor(),
                        (index) => const SizedBox(
                      width: 5,
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
