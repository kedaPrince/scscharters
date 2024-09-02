import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Model/trip_model.dart';
import '../repository/trip_repo.dart';

class TripController extends GetxController {
  final TripRepository tripRepository;
  TripController({required this.tripRepository});


  // Create an observable list to store search results
  final RxList<TripModel> trips = <TripModel>[].obs;

  // Add a variable to track loading state
  final RxBool isLoading = false.obs;

  // Add a variable to track error state
  final RxString error = ''.obs;

  // Function to search for trips
  Future<void> searchTrips(String fromName, String toName, DateTime? departureDate) async {
    try {
      isLoading.value = true; // Set loading state to true while fetching data

      // Call the repository to search for trips
      final List<TripModel> searchResults = await tripRepository.searchTrips(fromName, toName);

      // Filter the results based on the departureDate
      final filteredResults = searchResults.where((trip) {
        final formattedDepartureDate = DateFormat('yyyy-MM-dd').format(departureDate!);
        return trip.departureDate == formattedDepartureDate;
      }).toList();

      // Update the trips list with the search results
      trips.assignAll(filteredResults);

      isLoading.value = false; // Set loading state to false
      error.value = ''; // Clear any previous error message
    } catch (e) {
      isLoading.value = false; // Set loading state to false in case of an error
      error.value = 'Error: $e'; // Set error message
    }
  }
}
