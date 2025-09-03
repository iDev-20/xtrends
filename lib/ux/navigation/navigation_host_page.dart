import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/views/about/about_screen.dart';
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_outlined),
              label: AppStrings.home),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded),
              activeIcon: Icon(Icons.trending_up_rounded),
              label: AppStrings.trends),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border_rounded),
              activeIcon: Icon(Icons.bookmark_border_rounded),
              label: AppStrings.saved),
          BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              activeIcon: Icon(Icons.info_outline_rounded),
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
        return const AboutScreen();
      default:
        return const SizedBox();
    }
  }
}
