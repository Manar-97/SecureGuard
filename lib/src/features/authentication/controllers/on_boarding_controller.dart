import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:secure_guard/src/features/authentication/screens/home/home.dart';
import '../../../constants/color.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        bgColor: tOnBoardingPage1Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        bgColor: tOnBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        bgColor: tOnBoardingPage3Color,
      ),
    ),
  ];

  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide(BuildContext context) {
    int nextPage = controller.currentPage + 1;
    if (nextPage >= pages.length) {
      // إذا كانت الصفحة الحالية هي الأخيرة، انتقل إلى الشاشة الرئيسية
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      controller.animateToPage(
        page: nextPage,
      );
    }
  }

  onPageChangeCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
}
