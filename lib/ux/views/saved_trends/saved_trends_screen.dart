import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtrends/ux/shared/components/app_page.dart';
import 'package:xtrends/ux/shared/components/loading_widget.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/view_models.dart/saved_trends_view_model.dart';
import 'package:xtrends/ux/views/saved_trends/components/saved_trend_card.dart';
import 'package:xtrends/ux/views/saved_trends/components/saved_trend_empty_state.dart';

class SavedTrendsScreen extends StatefulWidget {
  const SavedTrendsScreen({super.key});

  @override
  State<SavedTrendsScreen> createState() => _SavedTrendsScreenState();
}

class _SavedTrendsScreenState extends State<SavedTrendsScreen> {
  bool initialLoad = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      await context.read<SavedTrendsViewModel>().loadSavedTrends();

      if (mounted) {
        setState(() {
          initialLoad = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      hideAppBar: true,
      body: Consumer<SavedTrendsViewModel>(builder: (context, viewModel, _) {
        if (initialLoad || viewModel.isLoading) {
          return const LoadingWidget();
        }

        if (viewModel.savedTrends.isEmpty) {
          return const SavedTrendsEmptyState();
        }

        return RefreshIndicator(
          color: AppColors.grey250,
          onRefresh: () async {
            await viewModel.loadSavedTrends();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.savedTrends.length,
            itemBuilder: (context, index) {
              final savedTrend = viewModel.savedTrends[index];
              return SavedTrendCard(savedTrend: savedTrend);
            },
          ),
        );
      }),
    );
  }
}
