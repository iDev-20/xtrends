import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
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
  bool initialLoadComplete = false;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadLocationsAndTrends();
    });
  }

  Future<void> loadLocationsAndTrends() async {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);

    try {
      await homeVM.loadLocation();

      if (homeVM.hasLocation) {
        await trendsVM.fetchTrends(country: homeVM.currentLocation);
      } else {
        debugPrint('No location available - skipping trends fetch');
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
    } finally {
      if (mounted) {
        setState(() {
          initialLoadComplete = true;
        });
      }
    }
  }

  Future<void> onRefresh() async {
    setState(() => isRefreshing = true);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);

    try {
      // await homeVM.refreshLocation();

      if (homeVM.hasLocation) {
        await trendsVM.refreshTrends(country: homeVM.currentLocation);
      }
    } catch (e) {
      debugPrint("Error during refresh: $e");
    } finally {
      if (mounted) setState(() => isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: Consumer2<HomeViewModel, TrendsViewModel>(
        builder: (context, homeVM, trendsVM, _) {
          return RefreshIndicator(
            color: AppColors.grey250,
            onRefresh: () async {
              onRefresh();
              return Future.value();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const HomeGreetingCard(),
                buildContent(homeVM, trendsVM),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    if (!initialLoadComplete ||
        shouldShowLoading(homeVM, trendsVM) ||
        homeVM.isHardRefresh) {
      return buildLoadingState(homeVM, trendsVM);
    }

    return HomeTrendingWidget(
      showShimmer: shouldShowShimmer(),
    );
  }

  bool shouldShowShimmer() {
    if (isRefreshing) {
      return true;
    }
    return false;
  }

  bool shouldShowLoading(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    final hasNoLocation = !homeVM.hasLocation;
    final isLocationLoading = homeVM.isLoadingLocation;
    final isTrendsLoading = trendsVM.isLoading;

    if (hasNoLocation && isLocationLoading) {
      return true;
    }

    if (isTrendsLoading && trendsVM.trends.isEmpty) {
      return true;
    }

    return false;
  }

  Widget buildLoadingState(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    String message = getLoadingMessage(homeVM, trendsVM);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: LoadingWidget(message: message),
    );
  }

  String getLoadingMessage(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    if (homeVM.isLoadingLocation && !homeVM.hasLocation ||
        homeVM.isHardRefresh) {
      return AppStrings.gettingYourLocation;
    }

    if (trendsVM.isLoading) {
      return homeVM.hasLocation
          ? '${AppStrings.fetchingLatestTrendsFor} ${homeVM.currentLocation}...'
          : AppStrings.fetchingLatestTrends;
    }

    return AppStrings.loading;
  }
}
