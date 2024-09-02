
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../Model/trip_model.dart';
import '../../Model/user_model.dart';
import '../../constants/colors.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/trip_controller.dart';
import '../../data/api_client.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../search/search_results.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => FirstHomePageState();
}

class FirstHomePageState extends State<HomePage> {
  final TripController tripController = Get.find();

  final TextEditingController _fromRegion = TextEditingController();
  final TextEditingController _toRegion = TextEditingController();
  final TextEditingController departureDateController = TextEditingController();


  int _counter = 1;
  bool _isOneWay = true;
  DateTime? _departureDate;
  List<String> regionSuggestions = [];
  String fromName = ""; // Initialize as empty strings
  String toName = "";



  @override
  Widget build(BuildContext context) {
    return homeWidget();
  }
  List<TripModel> getSearchResults(String from, String to, DateTime? departureDate) {
    if (departureDate != null) {
      return tripController.trips.where((trip) =>
      trip.fromName.toLowerCase() == from.toLowerCase() &&
          trip.toName.toLowerCase() == to.toLowerCase() &&
          trip.departureDate == DateFormat('yyyy-MM-dd').format(departureDate))
          .toList();
    } else {
      return []; // Return an empty list if no departureDate is selected
    }
  }



  @override
  void initState() {
    super.initState();
    fetchRegionList(); // Call the function to fetch region suggestions when the widget initializes
  }
  Future<void> fetchRegionList() async {
    final apiClient = ApiClient(baseUrl: AppConstants.BASE_URL);
    final regions = await apiClient.getAllTrips(); // Fetch all trips, including both fromName and toName

    final uniqueRegions = regions
        .map((region) => region.fromName.toLowerCase())
        .toSet()
        .toList();

    final uniqueToNames = regions
        .map((region) => region.toName.toLowerCase())
        .toSet()
        .toList();

    setState(() {
      regionSuggestions = [...uniqueRegions, ...uniqueToNames]; // Combine both fromName and toName suggestions
    });
  }





  Widget homeWidget() {
    final controller = Get.put(ProfileController());
    return Container(
      decoration: const BoxDecoration(

        color: Color(0xff171921),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
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
              child:  CircleAvatar(
                backgroundColor: AppColors.mainBlackColor.withOpacity(0.1),
                radius: 16,
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),

          ),

        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(AppLayout.getHeight(20)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: Dimensions.width30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 40,
                        ),
                        children: [
                          TextSpan(text: "Let's book "),
                          TextSpan(
                            text: "bus",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Customize the fontWeight for "bus"
                            ),
                          ),
                        ],
                      ),
                    ),
                    BigText(text: " tickets!", size: 40, color: Colors.white),
                  ],
                ),
              ),


              Stack(
                children: [
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        margin: const EdgeInsets.only(top: 60),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width - 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _counter = 1;
                                    _isOneWay = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isOneWay ? AppColors.orangeColor : Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'One Way',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _isOneWay ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _counter = 2;
                                    _isOneWay = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !_isOneWay ? AppColors.orangeColor : Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Round Trip',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: !_isOneWay ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //
              Gap(AppLayout.getHeight(20)),
              SizedBox(
                height: AppLayout.getHeight(200),
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      right: 15,
                      top: 20,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),

                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppLayout.getWidth(12),
                                horizontal: AppLayout.getWidth(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_location, color: Color(0xffeeeeee)),
                                  Gap(AppLayout.getWidth(10)),

                                  Gap(AppLayout.getWidth(15)),
                                  Expanded(
                                    child: TypeAheadField<String>(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: _fromRegion,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Enter Departure City',
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        final lowercasePattern = pattern.toLowerCase(); // Convert the pattern to lowercase
                                        return regionSuggestions.where((region) => region.contains(lowercasePattern)).toList();
                                      },

                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        _fromRegion.text = suggestion;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(AppLayout.getHeight(20)),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.add_location, color: Color(0xffeeeeee)),
                                  Gap(AppLayout.getWidth(10)),

                                  Expanded(
                                    child: TypeAheadField<String>(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: _toRegion,
                                        decoration:  InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Enter Destination City',
                                          hintStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        final lowercasePattern = pattern.toLowerCase();
                                        final filteredSuggestions = regionSuggestions
                                            .where((region) => region.toLowerCase().contains(lowercasePattern))
                                            .toList();
                                        return filteredSuggestions;
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        _toRegion.text = suggestion;
                                      },
                                    ),
                                  ),

                                ],

                              ),
                            ),
                          ),
                          Gap(AppLayout.getHeight(20)),
                          GestureDetector(
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(const Duration(days: 365)),
                                onConfirm: (date) {
                                  setState(() {
                                    _departureDate = date;
                                  });
                                },
                                currentTime: _departureDate ?? DateTime.now(),
                                locale: LocaleType.en,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 20.0, right: 20),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    child: Text(

                                      _departureDate != null
                                          ? DateFormat('dd MMM, yyyy').format(_departureDate!)
                                          : 'Select Departure Date',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      top: -45,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            final tmpText = _fromRegion.text;
                            _fromRegion.text = _toRegion.text;
                            _toRegion.text = tmpText;
                          });
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.orangeColor,
                          foregroundColor: Colors.white,
                          child: const Icon(Icons.sync),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppLayout.getHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 48.0),
                    child: Text(
                      'Passengers',
                      style: Styles.headLineStyle4,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 40.0),
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: const Color(0xff244d61),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _counter--;
                              if (_counter <= 1) _counter = 1;
                            });
                          },
                          icon: Icon(
                            Icons.remove,
                            color: _counter == 1 ? Colors.white: Colors.white,
                          ),
                        ),
                        Text('$_counter'),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_counter >= 1) {
                                _counter++;
                              }
                            });
                          },
                          icon: const Icon(Icons.add,color:Colors.white,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppLayout.getHeight(16),
              ),
              GestureDetector(
                onTap: () async {
                  if (kDebugMode) {
                    print('Search button tapped');
                  }
                  final String from = _fromRegion.text;
                  final String to = _toRegion.text;
                  final DateTime? departureDate = _departureDate;

                  if (departureDate != null) {
                    // Set isLoading to true to show loading state
                    tripController.isLoading.value = true;

                    // Clear any previous errors
                    tripController.error.value = '';

                    // Call the searchTrips function
                    await tripController.searchTrips(from, to, departureDate);

                    // Check for errors and display them
                    if (tripController.error.isNotEmpty) {
                      // Handle the error here, e.g., show an error message to the user
                      if (kDebugMode) {
                        print('Error: ${tripController.error}');
                      }
                    } else {
                      // Navigate to the SearchResultsPage with the search results
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(
                            searchResults: tripController.trips, // Pass the search results
                            isOneWay: _isOneWay,
                            passengerCount: _counter,
                            selectedDate: departureDate,
                            fromName: from,
                            toName: to,
                          ),
                        ),
                      );
                    }

                    // Set isLoading to false after the search is complete
                    tripController.isLoading.value = false;
                  } else {
                    if (kDebugMode) {
                      print('Please select a departure date.');
                    }
                  }
                },

        child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppLayout.getWidth(10)),
                    color: const Color(0xff262624),
                    gradient: const LinearGradient(
                      colors: [(Color(0xFFeb9f49)), (Color(0xFF262624)), (Color(0xFF262624))],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppLayout.getWidth(14),
                    horizontal: AppLayout.getWidth(15),
                  ),
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      Text(
                        'Search Your Trip',
                        style: Styles.textStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              Gap(AppLayout.getHeight(20)),


            ],
          ),

        ),

      ),
    );
  }
}
