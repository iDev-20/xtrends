import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/platform/extensions/string_extensions.dart';
import 'package:xtrends/platform/utils/general_utils.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';
import 'package:xtrends/ux/view_models.dart/home_view_model.dart';
import 'package:xtrends/ux/view_models.dart/trends_view_model.dart';
import 'package:xtrends/ux/views/trends/components/trend_card.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  bool initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadTrends();
    });
  }

  Future<void> loadTrends() async {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);

    try {
      if (homeVM.hasLocation) {
        await trendsVM.fetchTrends(country: homeVM.currentLocation);
      } else {
        debugPrint('No location available - skipping trends fetch');
      }
    } catch (e) {
      debugPrint('Error during trends initialization: $e');
    } finally {
      if (mounted) {
        setState(() {
          initialLoadComplete = true;
        });
      }
    }
  }

  Future<void> onRefresh() async {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final trendsVM = Provider.of<TrendsViewModel>(context, listen: false);

    try {
      if (homeVM.hasLocation) {
        await trendsVM.refreshTrends(country: homeVM.currentLocation);
      }
    } catch (e) {
      debugPrint("Error during trends refresh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, TrendsViewModel>(
      builder: (context, homeVM, trendsVM, _) {
        return buildContent(homeVM, trendsVM);
      },
    );
  }

  Widget buildContent(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    if (!initialLoadComplete || shouldShowLoading(homeVM, trendsVM)) {
      return buildLoadingState(homeVM, trendsVM);
    }

    return RefreshIndicator(
      color: AppColors.grey250,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trendsVM.trends.length,
        itemBuilder: (context, index) {
          final trend = trendsVM.trends[index];
          return TrendCard(
            index: index,
            trend: Utils.formatTrendName(trend: trend.trendName),
            noOfTweets:
                '${StringExtension.toTweetCount(trend.postCount)} Tweets',
          );
        },
      ),
    );
  }

  bool shouldShowLoading(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    final hasNoLocation = !homeVM.hasLocation;
    final isTrendsLoading = trendsVM.isLoading;

    if (hasNoLocation) {
      return true;
    }

    if (isTrendsLoading && trendsVM.trends.isEmpty) {
      return true;
    }

    return false;
  }

  Widget buildLoadingState(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    String message = getLoadingMessage(homeVM, trendsVM);

    return Center(
      child: LoadingWidget(message: message),
    );
  }

  String getLoadingMessage(HomeViewModel homeVM, TrendsViewModel trendsVM) {
    if (!homeVM.hasLocation) {
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
