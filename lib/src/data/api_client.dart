import 'dart:convert';
import 'dart:io'; // Import the 'dart:io' library
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Model/trip_model.dart';
import '../utils/app_constants.dart';

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<List<TripModel>> getAllTrips() async {
    final response = await http.get(Uri.parse('$baseUrl${AppConstants.REGION_URI}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      final List<TripModel> tripsList = responseData.map((data) => TripModel.fromJson(data)).toList();
      return tripsList;
    } else {
      throw Exception('Failed to load trip data');
    }
  }

  Future<List<TripModel>> searchTrips(String fromName, String toName) async {
    final response = await http.get(
        Uri.parse('$baseUrl${AppConstants.REGION_URI}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      final List<TripModel> tripsList = responseData.map((data) =>
          TripModel.fromJson(data)).toList();
      return tripsList;
    } else {
      throw Exception('Failed to load trip data');
    }
  }

  Future<Map<String, dynamic>> getBookedSeats(String departureDate) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${AppConstants.BOOKINGS_URI}?departure_date=$departureDate'),
      );

      // Add this line to print the API response for debugging
      if (kDebugMode) {
        print('API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('data')) {
          final List<dynamic> bookedSeatsData = responseData['data'];

          // Process the data
          for (var booking in bookedSeatsData) {
            // Access booking properties like 'id', 'seatsBooked', etc.
            // Parse other properties as needed.
          }
                }
      } else {
        // Handle API errors here, e.g., response.statusCode != 200.
        if (kDebugMode) {
          print('API Request Failed: ${response.statusCode}');
        }
      }


      throw Exception('Failed to load booked seats data');
    } catch (e) {
      throw Exception('Failed to fetch booked seats: $e');
    }
  }









  Future<http.Response> bookSeats(List<Map<String, dynamic>> seatsToBook) async {
    try {
      // Transform the list of seat maps to match the desired format
      final List<Map<String, dynamic>> transformedSeats = seatsToBook.map((
          seatMap) {
        final transformedSeat = Map<String, dynamic>.from(seatMap);

        // Modify the keys to match the snake_case format
        transformedSeat['seats_booked'] = seatMap['seats_booked'];
        // Use 'seatLabel' directly
        return transformedSeat;
      }).toList();

      // Use HttpClient for fine-grained control
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(
        Uri.parse('$baseUrl${AppConstants.BOOKINGS_URI}'),
      );

      // Set the request headers
      request.headers.set('Content-Type', 'application/json');

      // Encode the request body as JSON
      final requestBody = jsonEncode({
        'data': transformedSeats, // Wrap the seats in a 'data' key
      });
      if (kDebugMode) {
        print('Request Body: $requestBody');
      } // Add this line for debugging
      request.write(requestBody);


      // Send the request and receive the response
      final response = await request.close();

      // Decode the response body
      final responseBody = await utf8.decodeStream(response);

      // Create an http.Response object from the response
      final httpResponse = http.Response(responseBody, response.statusCode);

      // Close the HttpClient
      httpClient.close();

      return httpResponse;
    } catch (e) {
      throw Exception('Failed to book seats: $e');
    }
  }

}
