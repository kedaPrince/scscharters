import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';

import '../../constants/colors.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../../widgets/column_ticket_layout.dart';
import '../../widgets/layout_dotted_lines.dart';
import '../../widgets/thick_container.dart';

class TicketView extends StatefulWidget {
  final Map<String, dynamic> result;
  final bool? isColor;

  const TicketView({
    super.key,
    required this.result,
    this.isColor,
  });

  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  final _fromTec = TextEditingController();
  final _toTec = TextEditingController();

  @override
  void dispose() {
    _fromTec.dispose();
    _toTec.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return SizedBox(
      width: size.width * 0.82,
      height: AppLayout.getHeight(GetPlatform.isAndroid == true ? 167 : 169),
      child: Container(
        margin: EdgeInsets.only(right: AppLayout.getHeight(16)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppLayout.getHeight(16)),
                decoration: BoxDecoration(
                  color: widget.isColor == null ? const Color(0xffffffff) : Colors.black54,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.result['from']['code'],
                          style: widget.isColor == null
                              ? Styles.headLineStyle3.copyWith(color: const Color(0xff262624))
                              : Styles.headLineStyle3,
                        ),
                        Expanded(child: Container()),
                        const ThickContainer(isColor: true),
                        Expanded(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: AppLayout.getHeight(24),
                                child: const DottedLineLayout(sections: 6),
                              ),
                              Center(
                                child: Icon(
                                  Icons.bus_alert_rounded,
                                  color: widget.isColor == null ? const Color(0xff262624) : const Color(0xff262624),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ThickContainer(isColor: true),
                        Expanded(child: Container()),
                        Text(
                          widget.result['to']['code'],
                          style: widget.isColor == null
                              ? Styles.headLineStyle3.copyWith(color: const Color(0xff262624))
                              : Styles.headLineStyle3,
                        ),
                      ],
                    ),
                    Gap(AppLayout.getHeight(3)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: Text(
                            widget.result['from']['name'],
                            style: widget.isColor == null
                                ? Styles.headLineStyle4.copyWith(color: const Color(0xff262624))
                                : Styles.headLineStyle4,
                          ),
                        ),
                        Center(
                          child: Text(
                            widget.result['leaving_time'],
                            style: widget.isColor == null
                                ? Styles.headLineStyle4.copyWith(color: const Color(0xff262624))
                                : Styles.headLineStyle4,
                          ),
                        ),
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: Text(
                            widget.result['to']['name'],
                            textAlign: TextAlign.end,
                            style: widget.isColor == null
                                ? Styles.headLineStyle4.copyWith(color: const Color(0xff262624))
                                : Styles.headLineStyle4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: widget.isColor == null ? AppColors.darkColor : Colors.white,
                child: Row(
                  children: [
                    SizedBox(//half circle
                      height: AppLayout.getHeight(20),
                      width: AppLayout.getWidth(10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.isColor == null ? Colors.white : Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: LayoutBuilder(//horizonal lines
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(
                                (constraints.constrainWidth() / 15).floor(),
                                    (index) => SizedBox(
                                  width: 5,
                                  height: 1,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: widget.isColor == null ? Colors.white : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox( //half circle
                      height: AppLayout.getHeight(20),
                      width: AppLayout.getWidth(10),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.isColor == null ? Colors.white : Colors.grey.shade200,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: widget.isColor == null ? AppColors.white : Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(widget.isColor == null ? 21 : 0),
                    bottomRight: Radius.circular(widget.isColor == null ? 21 : 0),
                  ),
                ),
                padding: const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TicketColumnLayout(
                          firstText: widget.result['date'],
                          secondText: 'Date',
                          alignment: CrossAxisAlignment.start,
                          isColor: widget.isColor,
                        ),
                        TicketColumnLayout(
                          firstText: widget.result['departure_time'],
                          secondText: 'Departure',
                          alignment: CrossAxisAlignment.center,
                          isColor: widget.isColor,
                        ),
                        TicketColumnLayout(
                          firstText: '${widget.result['price']} \$AUD'.toString(),
                          secondText: 'Price',
                          alignment: CrossAxisAlignment.end,
                          isColor: widget.isColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
