import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/saved_trends/saved_trends_screen.dart';
import 'package:xtrends/ux/views/home/components/home_app_bar.dart';
import 'package:xtrends/ux/views/home/home_screen.dart';
import 'package:xtrends/ux/views/trends/trends_screen.dart';

class NavigationHostPage extends StatefulWidget {
  const NavigationHostPage({super.key});

  @override
  State<NavigationHostPage> createState() => _NavigationHostPageState();
}

class _NavigationHostPageState extends State<NavigationHostPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: getScreen(currentPage),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        selectedLabelStyle: const TextStyle(
            height: 1.8, fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(
            height: 1.8, fontSize: 12, fontWeight: FontWeight.w500),
        backgroundColor: AppColors.white,
        unselectedItemColor: AppColors.grey200,
        selectedItemColor: AppColors.primaryColor,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: AppImages.svgUnselectedHomeIcon,
              activeIcon: AppImages.svgSelectedHomeIcon,
              label: AppStrings.home),
          BottomNavigationBarItem(
              icon: AppImages.svgUnselectedHomeIcon,
              activeIcon: AppImages.svgSelectedHomeIcon,
              label: AppStrings.trends),
          BottomNavigationBarItem(
              icon: AppImages.svgUnselectedHomeIcon,
              activeIcon: AppImages.svgSelectedHomeIcon,
              label: AppStrings.saved),
          BottomNavigationBarItem(
              icon: AppImages.svgUnselectedHomeIcon,
              activeIcon: AppImages.svgSelectedHomeIcon,
              label: AppStrings.about),
        ],
      ),
    );
  }

  Widget getScreen(int value) {
    switch (value) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TrendsScreen();
      case 2:
        return const SavedTrendsScreen();
      case 3:
        return const HomeScreen();
      default:
        return const SizedBox();
    }
  }
}
