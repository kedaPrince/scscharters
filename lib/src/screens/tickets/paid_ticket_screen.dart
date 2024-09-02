import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/trip_model.dart';
import '../../constants/colors.dart';
import '../../controllers/bus_main_page_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import 'package:gap/gap.dart';
import '../../widgets/column_ticket_layout.dart';
import '../../widgets/layout_dotted_lines.dart';
import '../../widgets/thick_container.dart';
import '../home/bus_main_page.dart';

class PaidTicketScreen extends StatelessWidget {
  final BusMainPageController _busMainPageController = Get.find<BusMainPageController>(); // Initialize the controller
  final TripModel trip;
  final int passengerCount;
  final bool isOneWay;
  final List<String> selectedSeats;
  final double price;
  final bool? isColor;
 // final VoidCallback onSaveTicket;

  PaidTicketScreen({
    required this.trip,
    required this.passengerCount,
    required this.isOneWay,
    required this.selectedSeats,
    required this.price,
    this.isColor,
   //required this.onSaveTicket,
    required final Map<String, List<String>> bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    String ticketNumber = _generateTicketNumber();


    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.getHeight(20),
              vertical: AppLayout.getHeight(20),
            ),
            children: [
              Gap(AppLayout.getHeight(40)),
              Text('Tickets', style: Styles.headLineStyle),
              Gap(AppLayout.getHeight(40)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getHeight(20),
                  vertical: AppLayout.getHeight(12),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xfff4f6fd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Ticket', style: Styles.headLineStyle2),
                    ElevatedButton(
                      onPressed: () {
                        _saveTicket(context, ticketNumber,trip.toMap());
                        if (kDebugMode) {
                          print( trip.fromName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: const Text(
                          'Save Ticket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Gap(AppLayout.getHeight(20)),
              Container(
                padding: EdgeInsets.all(AppLayout.getHeight(16)),
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: isColor == null ? const Color(0xffffffff) : Colors.white,
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
                          trip.fromCode,
                          style: isColor == Colors.black54
                              ? Styles.headLineStyle3.copyWith(color: Colors.white)
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
                              const Center(
                                child: Icon(
                                  Icons.bus_alert_rounded,
                                  color: Color(0xff244d61),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ThickContainer(isColor: true),
                        Expanded(child: Container()),
                        Text(
                          trip.toCode,
                          style: isColor == Colors.black54
                              ? Styles.headLineStyle3.copyWith(color: Colors.white)
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
                            trip.fromName,
                            style: isColor == Colors.black54
                                ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                        Center(
                          child: Text(
                           trip.leavingTime,
                            style: isColor == Colors.black54
                                ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: Text(
                            trip.toName,
                            textAlign: TextAlign.end,
                            style: isColor == Colors.black54 ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getHeight(15),
                  vertical: AppLayout.getHeight(20),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(15),
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TicketColumnLayout(
                          firstText: 'Seats',
                          secondText: 'Passengers',
                          alignment: CrossAxisAlignment.start,
                          isColor: false,
                        ),
                        TicketColumnLayout(
                          firstText: selectedSeats.join(', '),
                          secondText: '$passengerCount',
                          alignment: CrossAxisAlignment.end,
                          isColor: false,
                        ),
                      ],
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TicketColumnLayout(
                          firstText: 'Trip Type',
                          secondText: 'Travel Hours',
                          alignment: CrossAxisAlignment.start,
                          isColor: false,
                        ),
                        TicketColumnLayout(
                          firstText: isOneWay ? 'One Way' : 'Round Trip',
                          secondText: trip.travelHours,
                          alignment: CrossAxisAlignment.end,
                          isColor: false,
                        ),
                      ],
                    ),
                    Gap(AppLayout.getHeight(10)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TicketColumnLayout(
                          firstText: 'Price',
                          secondText: '',
                          alignment: CrossAxisAlignment.start,
                          isColor: false,
                        ),
                        TicketColumnLayout(
                          firstText: '\$${price.toStringAsFixed(2)}',
                          secondText: '',
                          alignment: CrossAxisAlignment.end,
                          isColor: false,
                        ),
                      ],
                    ),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TicketColumnLayout(
                          firstText: 'Ticket number',
                          secondText: 'E-ticket number',
                          alignment: CrossAxisAlignment.start,
                          isColor: false,
                        ),
                        TicketColumnLayout(
                          firstText: ticketNumber,
                          secondText: ticketNumber,
                          alignment: CrossAxisAlignment.end,
                          isColor: false,
                        ),
                      ],
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/logo/Visa_Inc._logo.svg.png', scale: 26),
                                Text(' *** 4567', style: Styles.headLineStyle3),
                              ],
                            ),
                            Gap(AppLayout.getHeight(5)),
                            Text('Payment card', style: Styles.headLineStyle4),
                          ],
                        ),
                        TicketColumnLayout(
                          firstText: ticketNumber,
                          secondText: 'E-ticket number',
                          alignment: CrossAxisAlignment.end,
                          isColor: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getHeight(15),
                  vertical: AppLayout.getHeight(20),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(15),
                ),
                color: Colors.white,
                child:  Center(
                  child: GestureDetector(
                    onTap: () async {
                      final url = buildUrlWithData(price, trip.fromName,trip.toName);
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        if (kDebugMode) {
                          print("Could not launch URL: $url");
                        }
                      }
                    },
                    child: Center(
                      child: QrImageView(
                        data: buildUrlWithData(price,trip.fromName,trip.toName),
                        version: QrVersions.auto,
                        size: 150.0,
                      ),
                    ),
                  ),



                ),
              ),
            ],
          ),
          Positioned(
            left: AppLayout.getHeight(24),
            top: AppLayout.getHeight(295),
            child: Container(
              padding: EdgeInsets.all(AppLayout.getHeight(3)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textColor, width: 2),
              ),
              child: const CircleAvatar(
                maxRadius: 4,
                backgroundColor: AppColors.textColor,
              ),
            ),
          ),
          Positioned(
            right: AppLayout.getHeight(24),
            top: AppLayout.getHeight(295),
            child: Container(
              padding: EdgeInsets.all(AppLayout.getHeight(3)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textColor, width: 2),
              ),
              child: const CircleAvatar(
                maxRadius: 4,
                backgroundColor: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Save ticket logic
  void _saveTicket(BuildContext context, String ticketNumber, Map<String, dynamic> result) {
    // Save the ticket logic here
    final BusMainPageController _busMainPageController = Get.find<BusMainPageController>();
    _busMainPageController.saveTicket(trip, passengerCount, isOneWay, selectedSeats, price, ticketNumber);

    // Navigate back to BusBookingMainPage using named route
    Get.offAll(() => BusBookingMainPage());
  }

  String buildUrlWithData(double price, String from, String to) {
    const baseUrl = 'https://gryphonite.co.za/display-data.html';
    final encodedPrice = Uri.encodeComponent(price.toString());
    final encodedFrom = Uri.encodeComponent(from);
    final encodedTo = Uri.encodeComponent(to);

    return '$baseUrl?price=$encodedPrice&from=$encodedFrom&to=$encodedTo';
  }





  String _generateTicketNumber() {
    final random = Random.secure();
    final bytes = List.generate(8, (index) => random.nextInt(256));
    final ticketNumber = base64Url.encode(bytes).substring(0, 8);
    return ticketNumber;
  }
}
