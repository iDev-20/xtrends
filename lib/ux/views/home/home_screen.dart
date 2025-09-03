import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
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
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoadingLocation) {
            return const Center(
              child: LoadingWidget(
                  message: 'Please wait while we get your current location'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              HomeGreetingCard(),
              HomeTrendingWidget(),
            ],
          );
        },
      ),
    );
  }
}
