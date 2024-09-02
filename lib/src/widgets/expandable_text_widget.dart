import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({
    super.key,
    required this.text,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.text.isNotEmpty)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              widget.text,
              maxLines: isExpanded ? null : 2, // Control max lines here
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
