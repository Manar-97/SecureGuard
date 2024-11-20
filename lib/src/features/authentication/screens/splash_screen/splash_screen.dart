import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_guard/src/constants/color.dart';
import 'package:secure_guard/src/constants/image_strings.dart';
import 'package:secure_guard/src/constants/sizes.dart';
import 'package:secure_guard/src/constants/text_strings.dart';
import 'package:secure_guard/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  static const String routeName = "splash";
  final splashController = Get.put(SplashScreenController());

  Widget build(BuildContext context) {
    splashController.startAnimation();
    return Scaffold(
      body: Stack(
        children: [
          Obx( () => AnimatedPositioned(
              duration: const Duration(milliseconds: 1600),
              top: splashController.animate.value ? 0 : -30,
              left: splashController.animate.value ? 0 : -30,
              child: const Image(image: AssetImage(tSplashTopIcon))
            ),
          ),
          Obx( () => AnimatedPositioned(
            duration: const Duration(milliseconds: 1600),
            top: 80,
            left: splashController.animate.value ? tDefawltSize : -80,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1600),
              opacity: splashController.animate.value ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tAppName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    tAppTagLine,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ),
          ),
          Obx( () => AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            bottom: splashController.animate.value ? 100 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: splashController.animate.value ? 1 : 0,
              child: const Image(image: AssetImage(tSplashImage)),
            ),
          ),
          ),
          Obx( () => AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            bottom: splashController.animate.value ?  60 : 0,
            right: tDefawltSize,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: splashController.animate.value ? 1 :0,
              child: Container(
                width: tSplashContainerSize,
                height: tSplashContainerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: tPrimaryColor,
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
