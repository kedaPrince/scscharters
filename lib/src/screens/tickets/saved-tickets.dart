import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../controllers/bus_main_page_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/saved_ticket_controller.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../../widgets/column_ticket_layout.dart';
import '../../widgets/layout_dotted_lines.dart';
import '../../widgets/thick_container.dart';
import 'package:get/get.dart';

class SavedTickets extends StatefulWidget {

  final RxList<Map<String, dynamic>>? savedTicketsList;
  final Map<String, dynamic>? result;
  final int passengerCount;
  final bool isOneWay;
  final List<String> selectedSeats;
  final double price;
  final String ticketNumber;
  final VoidCallback onSaveTicket;
  final bool? isColor;
  SavedTickets({
    this.savedTicketsList,
    this.result,
    required this.passengerCount,
    required this.isOneWay,
    required this.selectedSeats,
    required this.price,
    required this.ticketNumber,
    required this.onSaveTicket,
    this.isColor,
  });

  @override
  _SavedTicketsState createState() => _SavedTicketsState();
}

class _SavedTicketsState extends State<SavedTickets> {
  final BusMainPageController _busMainPageController = Get.find<BusMainPageController>();
  final SavedTicketsController _savedTicketsController = Get.find<BusMainPageController>().savedTicketsController;

  List<bool> rowExpansionStates = []; // Initialize an empty list
  List<Map<String, dynamic>>? loadedSavedTickets;

  bool isExpanded = false;
  String qrCode = 'your_qr_code_data_here';



  @override
  void initState() {
    super.initState();
    loadedSavedTickets = widget.savedTicketsList;

    // Initialize rowExpansionStates with false for each saved ticket
    rowExpansionStates = List.generate(loadedSavedTickets!.length, (index) => false);
  }
  // Load saved tickets from BusMainPageController
  void loadSavedTickets() {
    loadedSavedTickets = _busMainPageController.savedTickets.toList();
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Container(
      width: double.infinity,
      color: const Color(0xff171921),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hi!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
              const SizedBox(height: 5,),
              FutureBuilder(
                  future: controller.getUserData(),
                  builder:(context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      if(snapshot.hasData){
                        UserModel user = snapshot.data as UserModel;
                        return Column(
                          children: [
                            Text(user.fullName, style: const TextStyle(fontSize: 14,color: Colors.white, fontWeight: FontWeight.w400),),
                          ],
                        );
                      }else if(snapshot.hasError){
                        return Center(child: Text(snapshot.error.toString()),);
                      }else{
                        return const Center(child: Text("Something went wrong"),);
                      }
                    }else{
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ],
          ),
          leading:   Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: CircleAvatar(
                backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
                radius: 16,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),

          ),
          actions:const [
            Padding(
              padding: EdgeInsets.only(top: 20, right: 30),
              child: Row(
                children: [
                Text('Saved Tickets', style:TextStyle(color: AppColors.yellowColor)),

                 Icon(LineAwesomeIcons.alternate_ticket,color:Colors.white),

                ],
              ),

              ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Text('My Tickets', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                ),
                Image.asset('assets/logo/bus.png'),
              ],
            ),
            Expanded(
              child: _savedTicketsController.savedTickets.isNotEmpty
                  ? ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getHeight(20),
                  vertical: AppLayout.getHeight(20),
                ),
                children: [
                  // Your other widgets here...
                  _buildSavedTicketsList(), // Display saved tickets
                ],
              )
                  : const Center(
                child: Text("No saved tickets available."),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Widget to build the loaded saved tickets list
  Widget _buildSavedTicketsList() {
    if (loadedSavedTickets == null || loadedSavedTickets!.isEmpty) {
      return const SizedBox.shrink(); // Return an empty widget if no loaded saved tickets
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: loadedSavedTickets!.length,
      itemBuilder: (context, index) {
        final savedTicket = loadedSavedTickets![index];
        final fromCode = savedTicket['from']?['code'];
        final fromName = savedTicket['from']?['name'];
        final toCode = savedTicket['to']?['code'];
        final toName = savedTicket['to']?['name'];
        final date = savedTicket['date'];
        final passengers = savedTicket['passengerCount'];
        final selectedSeats = savedTicket['selectedSeats'];
        final tripType = savedTicket['isOneWay'] ? 'One Way' : 'Round Trip';
        final ticketNumber = savedTicket['ticketNumber'];
        final time = savedTicket['leaving_time'];
        final ticketPrice = savedTicket['price'];



        rowExpansionStates.add(false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Gap(AppLayout.getHeight(20)),
            GestureDetector(
              onTap: () {
                setState(() {
                  rowExpansionStates[index] = !rowExpansionStates[index];
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                decoration: const BoxDecoration(
                  //color: rowExpansionStates[index] ? Color(0xFFffffff): Colors.transparent,
                  color:Color(0xFFffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),

                  ),
        ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '$fromCode',
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800, fontSize: 16),
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
                        const ThickContainer(isColor: false),
                        Expanded(child: Container()),
                        Text(
                          '$toCode',
                          style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800, fontSize: 16),
                        ),

                      ],
                    ),
                    const DottedLineLayout(sections: 15, isColor: true, width: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: Text(
                            '$fromName',
                            style: widget.isColor == Colors.black54
                                ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                        Center(
                          child: Text(
                            '$time',
                            style: widget.isColor == Colors.black54
                                ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: Text(
                            '$toName',
                            textAlign: TextAlign.end,
                            style: widget.isColor == Colors.black54
                                ? Styles.headLineStyle4.copyWith(color: Colors.white)
                                : Styles.headLineStyle4,
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Expanded content here
                      ],
                    ),
                    const DottedLineLayout(sections: 15, isColor: true, width: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const TicketColumnLayout(
                          firstText: 'Seats',
                          secondText: 'E-ticket number',
                          alignment: CrossAxisAlignment.start,
                          isColor: false,
                        ),

                        const SizedBox(height: 1),

                          TicketColumnLayout(
                            firstText:  '${selectedSeats.join(', ')}',
                            secondText:ticketNumber,
                            alignment: CrossAxisAlignment.end,
                            isColor: false,
                          ),

                      ],
                    ),
                    Gap(AppLayout.getHeight(20)),
                  ],
                ),

              ),
            ),
           // const SizedBox(height: 15),
            if (rowExpansionStates[index])
              Container(

                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(21),
                      bottomRight: Radius.circular(21)
                  ),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFffffff),AppColors.darkColor,AppColors.darkColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [

                    Gap(AppLayout.getHeight(6)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(20)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rowExpansionStates[index] = !rowExpansionStates[index];
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const  TicketColumnLayout(
                            firstText: 'Trip type',
                            secondText: 'Passengers',
                            alignment: CrossAxisAlignment.start,
                            isColor: false,
                          ),


                          if (rowExpansionStates[index])
                            TicketColumnLayout(
                              firstText: tripType,
                              secondText: '$passengers',
                              alignment: CrossAxisAlignment.end,
                              isColor: false,
                            ),

                        ],
                      ),
                    ),
                    Gap(AppLayout.getHeight(20)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(20)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rowExpansionStates[index] = !rowExpansionStates[index];
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const  TicketColumnLayout(
                            firstText: 'Date',
                            secondText: 'Price',
                            alignment: CrossAxisAlignment.start,
                            isColor: false,
                          ),


                          if (rowExpansionStates[index])
                            TicketColumnLayout(
                              firstText: '$date',
                              secondText: '\$${ticketPrice.toStringAsFixed(2)}',
                              alignment: CrossAxisAlignment.end,
                              isColor: false,
                            ),

                        ],
                      ),
                    ),

                    //qr code here
                    Gap(AppLayout.getHeight(20)),
                    const DottedLineLayout(sections: 15, isColor: false, width: 5),
                    Gap(AppLayout.getHeight(20)),
                    GestureDetector(
                      onTap: () async {
                        final url = buildUrlWithData(savedTicket['price'], savedTicket['from']?['name'], savedTicket['to']?['name'],
                          savedTicket['date'],
                          savedTicket['passengerCount'],
                          savedTicket['selectedSeats'],
                          savedTicket['isOneWay'] ? 'One Way' : 'Round Trip',
                          savedTicket['ticketNumber'],
                          savedTicket['leaving_time'],
                        );
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          if (kDebugMode) {
                            print("Could not launch URL: $url");
                          }
                        }
                        setState(() {
                          rowExpansionStates[index] = !rowExpansionStates[index];
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getHeight(15),
                          vertical: AppLayout.getHeight(20),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: AppLayout.getWidth(15),
                        ),
                       // color: const Color(0xFF332d2b),
                        child: Center(
                          child: QrImageView(
                            backgroundColor: Colors.white,
                            data: buildUrlWithData(savedTicket['price'].toDouble(),
                              savedTicket['from']?['name'],
                              savedTicket['to']?['name'],
                              savedTicket['date'],
                              savedTicket['passengerCount'].toDouble(),
                              savedTicket['selectedSeats'].join(', '), // Convert list to a string
                              savedTicket['isOneWay'] ? 'One Way' : 'Round Trip',
                              savedTicket['ticketNumber'],
                              savedTicket['leaving_time'],
                            ),
                            version: QrVersions.auto,
                            size: 150.0,
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
  // Generate URL for QR code
  String buildUrlWithData(double price, String from, String to,String date, double passengerCount,
      String selectedSeats, String isOneWay, String ticketNumber, String leavingTime) {
    const qrData = 'https://scscharters.co.za/display-data.html';
    final encodedPrice = Uri.encodeComponent(price.toString());
    final encodedFrom = Uri.encodeComponent(from);
    final encodedTo = Uri.encodeComponent(to);

    return '$qrData?price=$encodedPrice&from=$encodedFrom&to=$encodedTo';
  }
}
