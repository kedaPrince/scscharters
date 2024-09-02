import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scscharters/src/controllers/saved_ticket_controller.dart';
import 'package:scscharters/src/controllers/trip_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/trip_model.dart';
import '../screens/home/home.dart';
import '../screens/information/info_screen.dart';

import '../screens/tickets/saved-tickets.dart';
import '../screens/users/user_profile_screen.dart';


class BusMainPageController extends GetxController {
  late PageController pageController;
  late TripController tripController;
  RxList<Map<String, dynamic>> savedTickets = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 0.obs;
  RxBool isDarkTheme = false.obs;

  final SavedTicketsController savedTicketsController = Get.put(SavedTicketsController());
  late SavedTickets savedTicketsWidget;
  String qrCodeData = ''; // Variable to hold the QR code data
  Map<String, dynamic>? qrCodeTicketData; // Variable to hold the related ticket data

  List<Widget> pages = [
    const HomePage(),
    Container(),
    const InformationScreen(),
    const userProfileScreen(),
  ];

  Future<void> loadSavedTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTicketsJson = prefs.getString('saved_tickets');
    if (savedTicketsJson != null) {
      final savedTicketsData = json.decode(savedTicketsJson) as List<dynamic>;
      savedTickets.addAll(savedTicketsData.cast<Map<String, dynamic>>());
      savedTicketsController.setSavedTickets(savedTickets);
    }
  }

  Future<void> saveTicketsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTicketsJson = json.encode(savedTickets.toList());
    await prefs.setString('saved_tickets', savedTicketsJson);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    pageController = PageController();

    savedTicketsWidget = SavedTickets(
      savedTicketsList: savedTicketsController.savedTickets,
      result: null, // Provide the appropriate result map if needed
      passengerCount: 0, // Provide the appropriate passenger count
      isOneWay: false, // Provide the appropriate value for isOneWay
      selectedSeats: const [], // Provide the appropriate list of selected seats
      price: 0.0, // Provide the appropriate price
      ticketNumber: '', // Provide the appropriate ticket number
      onSaveTicket: () {}, // Provide the appropriate function for onSaveTicket
    );


    pages = [
      const HomePage(),
      savedTicketsWidget,
      const InformationScreen(),
      const userProfileScreen(),
    ];

    await loadSavedTickets();
  }

  void saveTicket(
      TripModel trip,
      int passengerCount,
      bool isOneWay,
      List<String> selectedSeats,
      double price,
      String ticketNumber,
      ) {
    // You can directly use the properties of the 'trip' parameter to construct the new ticket
    final newTicket = {
      'from': {
        'code': trip.fromCode,
        'name': trip.fromName,
      },
      'to': {
        'code': trip.toCode,
        'name': trip.toName,
      },
      'leaving_time': trip.leavingTime,
      'date': trip.date,
      'passengerCount': passengerCount,
      'isOneWay': isOneWay,
      'selectedSeats': selectedSeats,
      'price': price,
      'ticketNumber': ticketNumber,
    };

    savedTickets.add(newTicket);
    saveTicketsToStorage();

    savedTicketsController.addSavedTicket(newTicket);

    // Update the savedTicketsWidget with the new data
    savedTicketsWidget = SavedTickets(
      savedTicketsList: savedTicketsController.savedTickets,
      result: newTicket,
      passengerCount: passengerCount,
      isOneWay: isOneWay,
      selectedSeats: selectedSeats,
      price: price,
      ticketNumber: ticketNumber,
      onSaveTicket: () {
        // Handle the save ticket action here if needed
      },
    );

    // Update the pages list with the updated savedTicketsWidget
    pages[1] = savedTicketsWidget;

    // Update the UI
    update();
  }


  ThemeMode get theme => Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}

