import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../constants/colors.dart';
import '../../controllers/bus_main_page_controller.dart';
import '../../utils/color_constants.dart';
import 'package:get/get.dart';


class BusBookingMainPage extends StatelessWidget {
  BusBookingMainPage({super.key});

  final BusMainPageController _busMainPageController = Get.find<BusMainPageController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        notchMargin: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomAppBarItem(icon: IconlyLight.home, page: 0, context, label: "Home"),
                _bottomAppBarItem(icon: IconlyLight.ticket, page: 1, context, label: "Tickets"),
                _bottomAppBarItem(icon: IconlyLight.chart, page: 2, context, label: "Information"),
                _bottomAppBarItem(icon: IconlyLight.profile, page: 3, context, label: "Profile"),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _busMainPageController.pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: _busMainPageController.animateToTab,
        children: [..._busMainPageController.pages],
      ),
    );
  }

  Widget _bottomAppBarItem(BuildContext context, {required icon, required page, required label}) {
    return ZoomTapAnimation(
      onTap: () => _busMainPageController.goToTab(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _busMainPageController.currentPage == page ? ColorConstants.appColors : Colors.grey,
              size: 20,
            ),
            Text(
              label,
              style: TextStyle(
                  color: _busMainPageController.currentPage == page ? ColorConstants.appColors : Colors.grey,
                  fontSize: 13,
                  fontWeight: _busMainPageController.currentPage == page ? FontWeight.w600 : null),
            ),
          ],
        ),
      ),
    );
  }
}
