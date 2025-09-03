import 'package:flutter/material.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    this.backgroundColor = AppColors.primary50,
    this.title,
    this.centerTitle,
    this.hideAppBar,
    this.bottomNavigationBar,
    required this.body,
  });

  final Color backgroundColor;
  final String? title;
  final Widget body;
  final bool? centerTitle;
  final bool? hideAppBar;
  final BottomNavigationBar? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: (hideAppBar == true)
            ? null
            : AppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                leading: (hideAppBar == true)
                    ? null
                    : InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigation.back(context: context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                centerTitle: centerTitle ?? true,
                title: Text(title ?? ''),
                titleTextStyle: const TextStyle(
                    color: AppColors.darkBlueText,
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                titleSpacing: 0,
              ),
        body: SafeArea(child: body),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
