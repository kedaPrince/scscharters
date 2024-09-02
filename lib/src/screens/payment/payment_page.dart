
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import '../../Model/trip_model.dart';
import '../../Model/user_model.dart';
import '../../controllers/profile_controller.dart';
import '../../data/api_client.dart';
import '../../utils/app_constants.dart';
import '../tickets/paid_ticket_screen.dart';


class PaymentPage extends StatelessWidget {
  final TripModel trip;
  final int passengerCount;
  final bool isOneWay;
  final List<String> selectedSeats;
  final double price;
  final Map<String, List<String>> bookingData;
  final Function() fetchBookedSeatsCallback;

  PaymentPage({super.key,
    required this.trip,
    required this.passengerCount,
    required this.isOneWay,
    required this.selectedSeats,
    required this.price,
    required this.bookingData,
    required this.fetchBookedSeatsCallback,

  });
  final ApiClient apiClient = ApiClient(baseUrl: AppConstants.BASE_URL);
  UserModel? user;
  Future<UserModel?> getUserData() async {
    try {
      // Replace 'your_collection' with the actual Firestore collection name
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('your_collection');

      // Replace 'user_id' with the actual user ID you want to fetch data for
      const String userId = 'user_id';

      // Fetch user data by user ID
      final DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        // Extract user data from Firestore document
        final String fullName = userData['FullName'] as String;
        final String email = userData['Email'] as String;
        final String phoneNo = userData['Phone'] as String;
        final String password = userData['Password'] as String;

        // Create a UserModel instance
        final UserModel user = UserModel(
          fullName: fullName,
          email: email,
          phoneNo: phoneNo,
          password: password,
        );

        return user;
      } else {
        // User data not found in Firestore
        return null;
      }
    } catch (e) {
      // Handle any errors that may occur during data retrieval
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return null;
    }
  }
  void bookSelectedSeats() async {
    try {
      final departureDate = trip.departureDate;
      final fromCode = trip.fromCode;
      final fromName = trip.fromName;
      final toCode = trip.toCode;
      final toName = trip.toName;
      final leavingTime = trip.leavingTime;
      final date = trip.date;
      final price = trip.price;
      final departureTime = trip.departureTime;
      final arrivalTime = trip.arrivalTime;
      final arrivalDate = trip.arrivalDate;
      final travelHours = trip.travelHours;

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
        //fetchBookedSeats();
        fetchBookedSeatsCallback();
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

  Future<void> processPayPalPayment(BuildContext context) async {
    final isMounted = context.findRenderObject() != null;
    if (!isMounted) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: false,
          clientId:
          "AfxN11PNBmA1Y3x4AIi3rJ2SA-u2rYbmDUKT9b-IECEt1yjOQefXU-3d0Nso7zNGF6BvUE2pY8pMv1cl",

          secretKey:
          "EJAXbUPLRUvae5_HD5LJ9-l5aMINru5i2ebLFr6cF6MNaPQbAcglPqxcSno6OzewAA0IqNlNDaHrlDAe",

          returnURL: "https://scscharter.co.za/return.php",
          cancelURL: "https://scscharter.co.za/cancel.php",
          transactions:  [
            {
              "amount": {
                "total": price.toStringAsFixed(2), // Use the trip's price
                "currency": "AUD",
                "details": {
                  "subtotal": price.toStringAsFixed(2), // Use the trip's price
                  "shipping": 1,
                  "shipping_discount": 1,
                },
              },
              "description": "Trip payment for ${trip.fromName} to ${trip.toName}",

              "item_list": {
                "items": [
                  {
                    "name": trip.fromName ,
                    "quantity": passengerCount,
                    "price": price.toStringAsFixed(2), // Use the trip's price
                    "currency": "AUD",

                  }
                ],


              },
            },
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            if (!isMounted) {
              return;
            }


            if (kDebugMode) {
              print("onSuccess: $params");
            }
            bookSelectedSeats();
            await Get.to(
                  () => PaidTicketScreen(
                    trip: trip,
                    passengerCount: passengerCount,
                    isOneWay: isOneWay,
                    selectedSeats: selectedSeats,
                    price: price,
                    // Pass the updated booking data to PaidTicketScreen
                    bookingData: bookingData,


              ),
            );
          },
          onError: (error) {
            if (!isMounted) {
              return;
            }

            if (kDebugMode) {
              print("onError: $error");
            }
          },
          onCancel: (params) {
            if (!isMounted) {
              return;
            }

            if (kDebugMode) {
              print('cancelled: $params');
            }
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Price: \$${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            FutureBuilder<UserModel?>(
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
            GestureDetector(
              onTap: () {
                processPayPalPayment(context);
              },
              child: Column(
                children: [
                  const Text('Payment Confirmation'),
                  Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFeb9f49), Color(0xFF262624)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Click to Pay',style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
