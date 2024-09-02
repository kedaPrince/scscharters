import 'package:get/get.dart';
import '../Model/trip_model.dart';
import '../data/api_client.dart';

class TripRepository extends GetxService {
  final ApiClient apiClient;
  TripRepository({required this.apiClient});

  Future<List<TripModel>> searchTrips(String fromName, String toName) async {
    try {
      final List<TripModel> trips = await apiClient.searchTrips(fromName, toName);
      return trips;
    } catch (e) {
      throw Exception('Failed to search trips: $e');
    }
  }
}
