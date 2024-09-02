

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:scscharters/src/controllers/bus_main_page_controller.dart';
import 'package:scscharters/src/controllers/trip_controller.dart';
import 'package:scscharters/src/data/api_client.dart';
import 'package:scscharters/src/repository/authentication_repository/authentication_repository.dart';
import 'package:scscharters/src/repository/trip_repo.dart';
import 'package:scscharters/src/screens/home/bus_main_page.dart';
import 'package:scscharters/src/utils/app_constants.dart';
import 'package:scscharters/src/utils/themes.dart';

import 'firebase_options.dart';

void main() {

  //before run initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
          (value) {
            Get.put(AuthenticationRepository());
            Get.put(TripController(
              tripRepository: TripRepository(apiClient: ApiClient(baseUrl: AppConstants.BASE_URL)),
            ));

            Get.lazyPut(() => BusMainPageController());
            // Use Get.lazyPut
          }
  );

  runApp(AppLoader()); // Use AppLoader instead of MyApp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}


class AppLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GetBuilder<BusMainPageController>(
      init: BusMainPageController(),
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          themeMode: controller.theme,
          getPages: [
            GetPage(
              name: '/bus_main_page', // Define a named route for BusMainPage
              page: () => BusBookingMainPage(),
            ),
          ],
          home: Scaffold(
            body: Center(
              child: controller.savedTickets.isNotEmpty
                  ? BusBookingMainPage()
                  : const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}





