import 'package:flutter/material.dart';
import 'package:xtrends/platform/shared_pref.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/navigation/navigation_host_page.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/onboarding/walk_through_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializaApp();
  }

  void initializaApp() async {
    await Future.delayed(const Duration(seconds: 2));

    bool isFirstTime = await SharedPref.isFirstTime();
    
    if (mounted) {
      if (isFirstTime) {
        Navigation.navigateToScreenAndClearOnePrevious(
            context: context, screen: const WalkThroughScreen());
      } else {
        Navigation.navigateToScreenAndClearOnePrevious(
            context: context, screen: const NavigationHostPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary50,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: Image(image: AppImages.appLogo),
              ),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                    color: AppColors.darkBlueText,
                    fontSize: 36,
                    fontWeight: FontWeight.w800),
              ),
              const Text(
                AppStrings.discoverWhatsTrendingAnywhere,
                style: TextStyle(
                    color: AppColors.grey200,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
