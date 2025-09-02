import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppImages {
  AppImages._();

  //Images
  static AssetImage appLogo = const AssetImage('assets/images/app_logo.png');
  static AssetImage onboardingImage1 =
      const AssetImage('assets/images/onboarding_image_1.png');
  static AssetImage onboardingImage2 =
      const AssetImage('assets/images/onboarding_image_2.png');
  static AssetImage onboardingImage3 =
      const AssetImage('assets/images/onboarding_image_3.png');

  //Svgs
  static SvgPicture svgGreetingIcon =
      SvgPicture.asset('assets/svgs/greeting_icon.svg');
  static SvgPicture svgRefreshIcon =
      SvgPicture.asset('assets/svgs/refresh_icon.svg');
  static SvgPicture svgTrendIconWithStar =
      SvgPicture.asset('assets/svgs/trend_icon_with_star.svg');
  static SvgPicture svgCircleQuestioMark =
      SvgPicture.asset('assets/svgs/circle_questionMark.svg');
  static SvgPicture svgSearchIcon =
      SvgPicture.asset('assets/svgs/search_icon.svg');

  //bottom nav
  static SvgPicture svgUnselectedHomeIcon =
      SvgPicture.asset('assets/svgs/unselected_home_icon.svg');
  static SvgPicture svgSelectedHomeIcon =
      SvgPicture.asset('assets/svgs/selected_home_icon.svg');
}
