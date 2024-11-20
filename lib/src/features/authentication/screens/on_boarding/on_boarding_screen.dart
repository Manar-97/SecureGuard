import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:secure_guard/src/features/authentication/controllers/on_boarding_controller.dart';
import 'package:secure_guard/src/features/authentication/screens/home/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../constants/color.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final obcontroller = OnBoardingController();
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        LiquidSwipe(
          pages: obcontroller.pages,
          enableSideReveal: true,
          liquidController: obcontroller.controller,
          onPageChangeCallback: obcontroller.onPageChangeCallback,
          slideIconWidget: const Icon(Icons.arrow_back_ios),
        ),
        Positioned(
          bottom: 60.0,
          child: OutlinedButton(
            onPressed: () => obcontroller.animateToNextSlide(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.black26),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: tDarkColor, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            // onPressed: () => obcontroller.skip,
            child: const Text("skip", style: TextStyle(color: Colors.grey)),
          ),
        ),
        Obx(
          () => Positioned(
              bottom: 10,
              child: AnimatedSmoothIndicator(
                count: 3,
                activeIndex: obcontroller.currentPage.value,
                effect: const WormEffect(
                  activeDotColor: Color(0xff272727),
                  dotHeight: 5.0,
                ),
              )),
        ),
      ],
    ));
  }
}
