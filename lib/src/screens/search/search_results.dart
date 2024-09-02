
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../Model/trip_model.dart';
import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../controllers/profile_controller.dart';
import '../../data/api_client.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../../widgets/column_ticket_layout.dart';
import '../../widgets/dotted_line.dart';
import '../../widgets/horizontal_dotted_line.dart';
import '../bus_seats/bus_seats_page.dart';
import 'package:get/get.dart';
class SearchResultsPage extends StatefulWidget {
  final List<TripModel> searchResults;
  final bool isOneWay;
  final int passengerCount;
  final DateTime? selectedDate;
  final String fromName;
  final String toName;


  const SearchResultsPage({super.key,
    required this.searchResults,
    required this.isOneWay,
    required this.passengerCount,
    required this.selectedDate,
    required this.fromName,
    required this.toName,

  });

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  Offset busPosition = const Offset(-100, 0); // Initial position, off-screen to the left
  final ApiClient apiClient = ApiClient(baseUrl: AppConstants.BASE_URL);


  void startBusAnimation() {
    const finalPosition = Offset(0, 0);

    Future.delayed(Duration.zero, () {
      setState(() {
        busPosition = finalPosition;
      });
    });
  }
  Future<void> loadSearchResults() async {
    // Simulate a delay to load search results (replace with actual data fetching)
    await Future.delayed(const Duration(seconds: 2));
    // Set the loaded search results here
  }
  @override
  void initState() {
    super.initState();
    startBusAnimation();
  }

  bool tripMatchesSearchCriteria(TripModel trip) {
    final bool fromNameMatches = trip.fromName == widget.fromName;
    final bool toNameMatches = trip.toName == widget.toName;
    final bool dateMatches = widget.selectedDate != null &&
        DateFormat('yyyy-MM-dd').format(DateTime.parse(trip.date)) ==
            DateFormat('yyyy-MM-dd').format(widget.selectedDate!);

    return fromNameMatches && toNameMatches && dateMatches;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search Results!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
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
        backgroundColor: const Color(0xff171921),
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
        backgroundColor: const Color(0xff171921),
      body: FutureBuilder<void>(
        future: loadSearchResults(),
        builder: (context, snapshot){
          if(snapshot.connectionState ==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{ if(snapshot.hasError){
            return const Center(
            child: Text('Error loading search results'),
            );
    }else if(snapshot.hasData && widget.searchResults.isEmpty){
            return const Center(
              child: Text('No trips available for the selected date2'),
            );
    }else {
            return Column(
              children: [
                TweenAnimationBuilder<Offset>(
                  tween: Tween(begin: const Offset(-100, 0), end: busPosition),
                  duration: const Duration(seconds: 2),
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: offset,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset('assets/logo/bus.png'), // Replace with your bus image
                      ),
                    );
                  },
                ),
                Expanded(
                  child: widget.searchResults.isNotEmpty
                      ? ListView.builder(
                    itemCount: widget.searchResults.length,
                    itemBuilder: (context, index) {
                      final trip = widget.searchResults[index];
                      final totalTripPrice = trip.price * widget.passengerCount;

                      return Column(
                        children: [
                          if (tripMatchesSearchCriteria(trip))
                            Container(
                              width: double.infinity,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: AppColors.iPrimaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      width: double.infinity,
                                      height: 90,
                                      decoration: const BoxDecoration(
                                        color: AppColors.iPrimaryColor,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        height: 60.0,
                                        width: MediaQuery.of(context).size.width - 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              trip.fromName,
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
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return Flex(
                                                      direction: Axis.horizontal,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: List.generate(
                                                        (constraints.constrainWidth() / 5).floor(),
                                                            (index) => const SizedBox(
                                                          width: 4,
                                                          height: 2,
                                                          child: DecoratedBox(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.directions_bus,
                                              color: Color(0xff262624),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    return Flex(
                                                      direction: Axis.horizontal,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: List.generate(
                                                        (constraints.constrainWidth() / 5).floor(),
                                                            (index) => const SizedBox(
                                                          width: 4,
                                                          height: 2,
                                                          child: DecoratedBox(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
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
                                            Text(trip.toName),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                                              trip.fromCode,
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
                                              child: DottedLineWidget(),
                                            ),
                                            const Icon(
                                              Icons.directions_bus,
                                              color: Color(0xff262624),
                                            ),
                                            const Expanded(
                                              child: DottedLineWidget(),
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
                                              trip.toCode,
                                              style: Styles.headLineStyle3.copyWith(color: const Color(0xff262624)),
                                            ),
                                          ],
                                        ),
                                        const Gap(2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              trip.fromName,
                                              style: Styles.headLineStyle4.copyWith(color: const Color(0xff262624)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 78),
                                              child: Text(
                                                trip.travelHours,
                                                style: Styles.headLineStyle4.copyWith(color: const Color(0xff262624)),
                                              ),
                                            ),
                                            Text(
                                              trip.toName,
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
                                    child:  const Row(
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
                                              firstText: trip.departureDate,
                                              secondText: 'Departure Date',
                                              alignment: CrossAxisAlignment.start,
                                            ),
                                            TicketColumnLayout(
                                              firstText: trip.leavingTime,
                                              secondText: 'Boarding Time',
                                              alignment: CrossAxisAlignment.center,
                                            ),
                                            TicketColumnLayout(
                                              firstText: trip.departureTime,
                                              secondText: 'Dep Time',
                                              alignment: CrossAxisAlignment.center,
                                            ),


                                          ],
                                        ),
                                        const Gap(20),
                                        const HorizontalDottedLines(),
                                        const Gap(15),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TicketColumnLayout(
                                              firstText: '\$$totalTripPrice AUD',
                                              secondText: 'Price',
                                              alignment: CrossAxisAlignment.start,
                                            ),
                                            TicketColumnLayout(
                                              firstText: trip.arrivalDate,
                                              secondText: 'Arrival Date',
                                              alignment: CrossAxisAlignment.center,
                                            ),
                                            TicketColumnLayout(
                                              firstText: trip.arrivalTime,
                                              secondText: 'Arrival Time',
                                              alignment: CrossAxisAlignment.center,
                                            ),

                                          ],
                                        ),
                                        const HorizontalDottedLines(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TicketColumnLayout(
                                              firstText: 'Trip :',
                                              secondText: widget.isOneWay ? 'One Way' : 'Round Trip',
                                              alignment: CrossAxisAlignment.start,
                                            ),
                                            TicketColumnLayout(
                                              firstText: 'Passengers :',
                                              secondText: '${widget.passengerCount}',
                                              alignment: CrossAxisAlignment.center,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(AppLayout.getWidth(10)),
                                                color: const Color(0xff262624),
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                onPressed: () {
                                                  // Navigate to bus seats page
                                                  _navigateToBusSeatsPage(context, trip);
                                                },
                                                child: const Text('Select Seats'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                      : Container(
                    alignment: Alignment.center,
                    child: const Text('No trips available for the selected date.'),
                  ),
                ),
              ],
            );
          }
    }
        },
      )
    );
  }

  void _navigateToBusSeatsPage(BuildContext context, TripModel trip) async {
    if (kDebugMode) {
      print('_navigateToBusSeatsPage called');
    } // Debugging line
    try {
      final selectedDate = widget.selectedDate;
      if (selectedDate == null) {
        throw Exception('Selected date is null.');
      }

      final departureDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Print the departureDate for debugging
      if (kDebugMode) {
        print('Departure date from _navigateToBusSeatsPage: $departureDate');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusSeatsPage(
            trip: trip,
            passengerCount: widget.passengerCount,
            isOneWay: widget.isOneWay,
            // Pass the departureDate here
            departureDate: departureDate,

          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error navigating to BusSeatsPage: $e');
      }
    }
  }









}
