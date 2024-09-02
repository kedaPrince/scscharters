import 'package:flutter/material.dart';

class SavedTicketsWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? savedTicketsList;
  final Map<String, dynamic>? result;
  final int passengerCount;
  final bool isOneWay;
  final List<String> selectedSeats;
  final double price;
  final String ticketNumber;
  final VoidCallback onSaveTicket;

  SavedTicketsWidget({
    this.savedTicketsList,
    this.result,
    required this.passengerCount,
    required this.isOneWay,
    required this.selectedSeats,
    required this.price,
    required this.ticketNumber,
    required this.onSaveTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Saved Tickets',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildSavedTicketsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedTicketsList() {
    if (savedTicketsList != null && savedTicketsList!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: savedTicketsList!.length,
        itemBuilder: (context, index) {
          final savedTicket = savedTicketsList![index];
          return ListTile(
            title: Text(savedTicket['from']['name']),
          );
        },
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No saved tickets'),
      );
    }
  }
}



