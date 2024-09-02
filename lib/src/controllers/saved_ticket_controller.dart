import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SavedTicketsController extends GetxController {
  RxList<Map<String, dynamic>> savedTickets = <Map<String, dynamic>>[].obs;

  Future<void> loadSavedTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTicketsJson = prefs.getString('saved_tickets');
    if (savedTicketsJson != null) {
      final savedTicketsData = json.decode(savedTicketsJson) as List<dynamic>;
      savedTickets.addAll(savedTicketsData.cast<Map<String, dynamic>>());
    }
  }

  Future<void> saveTicketsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTicketsJson = json.encode(savedTickets.toList());
    await prefs.setString('saved_tickets', savedTicketsJson);
  }

  void addSavedTicket(Map<String, dynamic> newTicket) {
    savedTickets.add(newTicket);
    saveTicketsToStorage();
  }
  void setSavedTickets(List<Map<String, dynamic>> newSavedTickets) {
    savedTickets.assignAll(newSavedTickets);
  }
}
