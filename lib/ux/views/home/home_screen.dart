import 'package:flutter/material.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/views/home/components/home_greeting_card.dart';
import 'package:xtrends/ux/views/home/components/home_trending_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HomeGreetingCard(),
          HomeTrendingWidget(),
        ],
      ),
    );
  }
}
