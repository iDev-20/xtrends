import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/home/components/home_greeting_card.dart';
import 'package:xtrends/ux/views/home/components/home_trending_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homeVM = Provider.of<HomeViewModel>(context, listen: false);
      final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);

      await homeVM.loadLocation();

      if (homeVM.currentLocation != null) {
        await trendsVM.fetchTrends();
      } else {
        debugPrint("No location provided — skipping trends fetch");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: Consumer2<HomeViewModel, TrendsViewModel>(
        builder: (context, homeVM, trendsVM, _) {
          if (homeVM.isLoadingLocation || trendsVM.isLoading) {
            return const Center(
              child: LoadingWidget(
                  message: 'Fetching your location and latest trends...'),
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
