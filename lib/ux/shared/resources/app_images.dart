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
  static AssetImage xLogo = const AssetImage('assets/images/x_logo_frame.png');

  //Svgs
  static SvgPicture svgSlide1 =
      SvgPicture.asset('assets/svgs/slide_1.svg', height: 220, width: 220);
  static SvgPicture svgSlide2 = SvgPicture.asset('assets/svgs/slide_2.svg');
  static SvgPicture svgSlide3 = SvgPicture.asset('assets/svgs/slide_3.svg');
  static SvgPicture svgGreetingIcon =
      SvgPicture.asset('assets/svgs/greeting_icon.svg');
  static SvgPicture svgRefreshIcon =
      SvgPicture.asset('assets/svgs/refresh_icon.svg');
  static SvgPicture svgTrendIconWithStar =
      SvgPicture.asset('assets/svgs/trend_icon_with_star.svg');
  static SvgPicture svgCircleQuestioMark =
      SvgPicture.asset('assets/svgs/circle_question_mark.svg');
  static SvgPicture svgHowItWorksIcon =
      SvgPicture.asset('assets/svgs/how_it_works_icon.svg');
  static SvgPicture svgPrivacyIcon =
      SvgPicture.asset('assets/svgs/privacy_icon.svg');
  static SvgPicture svgSearchIcon =
      SvgPicture.asset('assets/svgs/search_icon.svg');
  static SvgPicture svgBackIcon = SvgPicture.asset('assets/svgs/back_icon.svg');
  static SvgPicture svgRankIcon = SvgPicture.asset('assets/svgs/rank_icon.svg');
  static SvgPicture svgStarIcon =
      SvgPicture.asset('assets/svgs/star_icon.svg', height: 24, width: 24);

  //bottom nav
  static SvgPicture svgUnselectedHomeIcon =
      SvgPicture.asset('assets/svgs/bottom-nav/unselected_home_icon.svg');
  static SvgPicture svgSelectedHomeIcon =
      SvgPicture.asset('assets/svgs/bottom-nav/selected_home_icon.svg');
}
