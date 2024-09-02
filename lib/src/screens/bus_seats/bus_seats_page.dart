
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../Model/trip_model.dart';
import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../controllers/profile_controller.dart';
import '../../data/api_client.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_styles.dart';
import '../../widgets/column_ticket_layout.dart';
import '../../widgets/horizontal_dotted_line.dart';
import '../payment/payment_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



class BusSeatsPage extends StatefulWidget {
  final TripModel trip;
  final int passengerCount;
  final bool isOneWay;
  //final Map<String, dynamic> bookedSeats;
  final String departureDate;

  BusSeatsPage({
    required this.trip,
    required this.passengerCount,
    required this.isOneWay,
   // required this.bookedSeats,
    required this.departureDate
  });

  @override
  _BusSeatsPageState createState() => _BusSeatsPageState();
}

class _BusSeatsPageState extends State<BusSeatsPage> {
 // List<List<Color>> seatColors = List.generate(10, (_) => List.filled(4, const Color(0xff1C313B)),);
  List<String> selectedSeats = [];
  Map<String, List<String>> bookingData = {};
  Map<String, List<Map<String, dynamic>>> bookedSeats = {};
  List<List<VoidCallback?>> seatTapActions = [];
  List<String> bookedSeatLabels = [];



  static const Color availableSeatColor = const Color(0xff1C313B);
  static const Color selectedSeatColor = Colors.orange;
  static const Color bookedSeatColor = Colors.grey;
  List<List<Color>> seatColors = List.generate(10, (_) => List.filled(4, availableSeatColor));
  final ApiClient apiClient = ApiClient(baseUrl: AppConstants.BASE_URL);
  static const int rows = 10;
  static const int cols = 4;
  String? departureDate;


  @override
  void initState() {
    super.initState();
    // Initialize seatColors with availableSeatColor
    seatColors = List.generate(
      rows,
          (row) => List.generate(
        cols,
            (col) {
          String seatLabel = String.fromCharCode(65 + row) + (col + 1).toString();
          return isSeatBooked(seatLabel) ? bookedSeatColor : availableSeatColor;
        },
      ),
    );
    if (kDebugMode) {
      print('widget.departureDate: ${widget.departureDate}');
    }
    departureDate = widget.departureDate;
    // Fetch booked seats when the page is loaded
    fetchBookedSeats();

    // Update seat colors based on booked seats
    updateSeatColorsForBookedSeats([]);
    seatTapActions = List.generate(10, (row) => List.generate(4, (col) => () => updateSeatColor(row, col, bookedSeatLabels)));


  }

  // Function to book selected seats
  void bookSelectedSeats() async {
    try {
      final departureDate = widget.trip.departureDate;
      final fromCode = widget.trip.fromCode;
      final fromName = widget.trip.fromName;
      final toCode = widget.trip.toCode;
      final toName = widget.trip.toName;
      final leavingTime = widget.trip.leavingTime;
      final date = widget.trip.date;
      final price = widget.trip.price;
      final departureTime = widget.trip.departureTime;
      final arrivalTime = widget.trip.arrivalTime;
      final arrivalDate = widget.trip.arrivalDate;
      final travelHours = widget.trip.travelHours;

      final selectedSeatLabels = selectedSeats;

      // Create a list of seats to book with all required keys
      final List<Map<String, dynamic>> seatsToBook = selectedSeatLabels
          .map((seatLabel) => {
        'seats_booked': seatLabel, // Correct the key name
        'from_code': fromCode, // Correct the key name
        'from_name': fromName, // Correct the key name
        'to_code': toCode, // Correct the key name
        'to_name': toName, // Correct the key name
        'leaving_time': leavingTime, // Correct the key name
        'date': date, // Correct the key name
        'price': price, // Correct the key name
        'departure_date': departureDate, // Correct the key name
        'departure_time': departureTime, // Correct the key name
        'arrival_date': arrivalDate, // Correct the key name
        'arrival_time': arrivalTime, // Correct the key name
        'travel_hours': travelHours, // Correct the key name
        // Add any other necessary data for your API request
      })
          .toList();


      // Make a POST request to book selected seats using your API client
      final response = await apiClient.bookSeats(seatsToBook);

      if (response.statusCode == 200) {
        // Seats booked successfully
        // You can handle the success response here
        // Clear selected seats after booking
        selectedSeats.clear();
        // Refresh the booked seats information
        fetchBookedSeats();
      } else {
        // Handle API error here
        if (kDebugMode) {
          print('Failed to book seats: ${response.statusCode}');
        }
        // Display an error message to the user
      }
    } catch (e) {
      // Handle network or other errors here
      if (kDebugMode) {
        print('Error booking seats: $e');
      }
      // Display an error message to the user
    }
  }


  // Function to fetch booked seats for the current trip's departure date
  Future<void> fetchBookedSeats() async {
    try {
      const String apiEndpoint = 'https://app.scscharters.co.za/api/v1/bookings';

      final http.Response response = await http.get(Uri.parse(apiEndpoint));


      if (response.statusCode == 200) {
        // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> seatBookings = responseData['data'];

        if (seatBookings.isNotEmpty) {
          // Filter and print seat bookings that match the search criteria
          final filteredBookings = seatBookings.where((booking) {
            final fromName = booking['fromName'];
            final toName = booking['toName'];
            final departureDate = booking['departureDate'];

            return fromName == widget.trip.fromName &&
                toName == widget.trip.toName &&
                departureDate == widget.departureDate;
          }).toList();

          if (filteredBookings.isNotEmpty) {
            if (kDebugMode) {
              print('Seat bookings matching search criteria:');
            }
            for (var booking in filteredBookings) {
              if (kDebugMode) {
                print('Seat Booked: ${booking['seatsBooked']}');
              }
              if (kDebugMode) {
                print('From Name: ${booking['fromName']}');
              }
              if (kDebugMode) {
                print('To Name: ${booking['toName']}');
              }
              // Add more fields as needed
              if (kDebugMode) {
                print('---');
              }
            }

            // Extract the seat labels from the filtered bookings

            final bookedSeatLabels = filteredBookings.map((booking) => booking['seatsBooked'].toString()).toList();

// Update the seat colors to grey for booked seats
            updateSeatColorsForBookedSeats(bookedSeatLabels);

          } else {
            if (kDebugMode) {
              print('No seat bookings found matching the search criteria.');
            }
          }
        } else {
          if (kDebugMode) {
            print('No seat bookings found');
          }
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch seat bookings: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while fetching seat bookings: $e');
      }
    }
  }

  bool isSeatBooked(String seatLabel) {
    if (departureDate == null) {
      return false;
    }

    final bookedSeatData = bookedSeats[departureDate!];

    if (bookedSeatData != null) {
      return bookedSeatData.any((bookingData) => bookingData['seatsBooked'] == seatLabel);
    }

    return false;
  }




  void updateSeatColor(int row, int col, List<String> bookedSeatLabels) {
    String seatLabel = String.fromCharCode(65 + row) + (col + 1).toString();
    bool isBooked = isSeatBooked(seatLabel);

    setState(() {
      if (isBooked) {
        // If the seat is already booked, do not allow selection
        return;
      }

      if (selectedSeats.contains(seatLabel)) {
        // If the seat is already selected, deselect it
        selectedSeats.remove(seatLabel);
      } else if (selectedSeats.length < widget.passengerCount) {
        // If the seat is not selected and the user can select more seats, select it
        selectedSeats.add(seatLabel);
      }

      // Update seat colors based on selectedSeats and booked seats
      if (selectedSeats.contains(seatLabel)) {
        seatColors[row][col] = selectedSeatColor;
      } else if (bookedSeatLabels.contains(seatLabel)) {
        seatColors[row][col] = bookedSeatColor;
      } else {
        seatColors[row][col] = availableSeatColor;
      }
    });
  }

  void updateSeatColorsForDate(String date) {
    setState(() {
      final bookedSeatLabels = bookedSeats[date] ?? [];
      for (int row = 0; row < 10; row++) {
        for (int col = 0; col < 4; col++) {
          String seatLabel = String.fromCharCode(65 + row) + (col + 1).toString();
          if (selectedSeats.contains(seatLabel)) {
            seatColors[row][col] = selectedSeatColor;
          } else if (bookedSeatLabels.contains(seatLabel)) {
            seatColors[row][col] = bookedSeatColor; // Display booked seats in grey
          } else {
            seatColors[row][col] = availableSeatColor;
          }
        }
      }
    });
  }

  // Function to update seat colors based on booked seats
  void updateSeatColorsForBookedSeats(List<String> bookedSeatLabels) {
    setState(() {
      for (int row = 0; row < 10; row++) {
        for (int col = 0; col < 4; col++) {
          String seatLabel = String.fromCharCode(65 + row) + (col + 1).toString();
          bool isSeatSelected = selectedSeats.contains(seatLabel);

          if (isSeatSelected) {
            seatColors[row][col] = selectedSeatColor;
          } else if (bookedSeatLabels.contains(seatLabel)) {
            if (kDebugMode) {
              print('Seat $seatLabel is booked for departure date: $departureDate');
            }
            seatColors[row][col] = bookedSeatColor;

            // Set onTap to null for booked seats to disable clicking
            seatTapActions[row][col] = null;
          } else {
            seatColors[row][col] = availableSeatColor;
          }
        }
      }
    });
  }

  List<Widget> buildSeatRow(int row) {
    List<Widget> seatRow = [];

    for (int col = 0; col < 4; col++) {
      String seatLabel = String.fromCharCode(65 + row) + (col + 1).toString();

      seatRow.add(
        GestureDetector(
          onTap: seatTapActions[row][col],
          child: Container(
            margin: const EdgeInsets.all(4.0),
            width: 30.0,
            height: 30.0,
            color: isSeatBooked(seatLabel) ? bookedSeatColor : seatColors[row][col], // Remove departureDate argument
            child: Center(
              child: Text(
                seatLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

    }

    return seatRow;
  }

  List<Widget> buildSeatRows() {
    List<Widget> seatRows = [];

    for (int row = 0; row < 10; row++) {
      List<Widget> seatRow = buildSeatRow(row);
      seatRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: seatRow,
      ));
    }

    return seatRows;
  }

  @override
  Widget build(BuildContext context) {
    // Handle null result and passengerCount gracefully
    double price = (widget.trip.price).toDouble() * widget.passengerCount;
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xff171921),
      appBar: AppBar(
        title:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seat Selection!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_sharp,
            size: 35,
            color: Color(0xfff3bd53),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: AppColors.iPrimaryColor,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
                Icons.notification_add,
                color: Color(0xffffffff),
              ),

          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
                backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
                radius: 16,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),

          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.iPrimaryColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
            ),
            child: const SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_seat, color: Color(0xff1C313B)),
                        Text('Available', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                        Gap(10),
                        Icon(Icons.event_seat, color: Colors.orange),
                        Text('Selected', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                        Gap(10),
                        Icon(Icons.event_seat, color: Colors.grey),
                        Text('Booked', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(21),
                          topRight: Radius.circular(21),
                        ),
                        color: Color(0xfff3bd53),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.trip.leavingTime,
                                style: Styles.headLineStyle3.copyWith(color: const Color(0xff262624)),
                              ),
                              Expanded(child: Container()),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.5, color: const Color(0xff262624)),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: HorizontalDottedLines(),
                                ),
                              ),
                              const Icon(
                                Icons.directions_bus,
                                color: Color(0xff262624),
                              ),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: HorizontalDottedLines(),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.5, color: const Color(0xff262624)),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                              Text(
                                widget.trip.arrivalTime,
                                style: Styles.headLineStyle3.copyWith(color: const Color(0xff262624)),
                              ),
                            ],
                          ),
                          const Gap(2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.trip.fromName,
                                style: Styles.headLineStyle4.copyWith(color: const Color(0xff262624)),
                              ),
                              Text(
                                widget.trip.travelHours,
                                style: Styles.headLineStyle4.copyWith(color: const Color(0xff262624)),
                              ),
                              Text(
                                widget.trip.toName,
                                style: Styles.headLineStyle4.copyWith(color: const Color(0xff262624)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 2,
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: const Row(
                        children: [
                          SizedBox(
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: HorizontalDottedLines(),
                          ),
                          SizedBox(
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
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
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TicketColumnLayout(
                                firstText:  widget.trip.date,
                                secondText: 'Date',
                                alignment: CrossAxisAlignment.start,
                              ),
                              TicketColumnLayout(
                                firstText:  widget.trip.departureTime,
                                secondText: 'Departure',
                                alignment: CrossAxisAlignment.center,
                              ),
                              TicketColumnLayout(
                                firstText: '\$${price.toStringAsFixed(2)} AUD',
                                secondText: 'Price',
                                alignment: CrossAxisAlignment.end,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                            child: Row(
                              children: [
                                Expanded(
                                  child: HorizontalDottedLines(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TicketColumnLayout(
                                firstText: 'Trip:',
                                secondText: widget.isOneWay ? 'One Way' : 'Round Trip',
                                alignment: CrossAxisAlignment.start,
                              ),
                              TicketColumnLayout(
                                firstText: 'Passengers:',
                                secondText: '${widget.passengerCount}',
                                alignment: CrossAxisAlignment.center,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff262624),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Seats Selected',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              ((selectedSeats.length - 0) / 1).ceil(),
                                  (colIndex) {
                                int startIndex = (colIndex * 1);
                                int endIndex = (startIndex + 1).clamp(0, selectedSeats.length);
                                List<String> columnSeats = selectedSeats.sublist(startIndex, endIndex);

                                return Row(
                                  children: [
                                    Column(
                                      children: columnSeats.map(
                                            (seat) => Row(
                                          children: [
                                            const Icon(
                                              Icons.event_seat,
                                              color: Colors.orange,
                                            ),
                                            Text(seat),
                                          ],
                                        ),
                                      ).toList(),
                                    ),
                                    if (columnSeats.length == 8 && endIndex < selectedSeats.length)
                                      const SizedBox(width: 16), // Adjust the spacing between columns here
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: buildSeatRows(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xff262624),
                ),
                margin: const EdgeInsets.only(left: 90, right: 90, bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff262624), // Background color
                  ),
                  onPressed: () {
                    if (selectedSeats.isEmpty) {
                      // Show a SnackBar if no seats are selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a seat first.'),
                        ),
                      );
                    } else {
                      //bookSelectedSeats();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            trip: widget.trip,
                            passengerCount: widget.passengerCount,
                            isOneWay: widget.isOneWay,
                            selectedSeats: selectedSeats,
                            price: price,
                            bookingData: bookingData,
                            fetchBookedSeatsCallback: () {
                              // Implement the actual fetchBookedSeats logic here
                              fetchBookedSeats();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.event_seat,
                        color: Colors.white,
                      ),
                      Text(
                        'Book Your Seat Now',
                        style: Styles.textStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),


              ),
            ],
          ),
        ],
      ),
    );
  }

}
