import 'package:flutter/material.dart';
import 'package:xtrends/ux/navigation/navigation.dart';
import 'package:xtrends/ux/navigation/navigation_host_page.dart';
import 'package:xtrends/ux/shared/components/app_buttons.dart';
import 'package:xtrends/ux/shared/components/app_form_fields.dart';
import 'package:xtrends/ux/shared/components/slide_indicator.dart';
import 'package:xtrends/ux/shared/models/ui_models.dart';
import 'package:xtrends/ux/shared/resources/app_colors.dart';
import 'package:xtrends/ux/shared/resources/app_images.dart';
import 'package:xtrends/ux/shared/resources/app_strings.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({super.key});

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final Duration _slideAnimationDuration = const Duration(milliseconds: 500);

  final List<Carousel> _slideList = [
    Carousel(
      image: AppImages.svgSlide1,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
    ),
    Carousel(
      image: AppImages.svgSlide2,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
    ),
    Carousel(
      image: AppImages.svgSlide3,
      title: AppStrings.whatShouldWeCallYou,
      subtitle: AppStrings.letsGetToKnowEachOther,
    ),
  ];

  bool userControl = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == 2;
    return Scaffold(
      backgroundColor:
          _currentPage == 1 ? AppColors.primary50 : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 64),
            Expanded(
              child: PageView.builder(
                padEnds: false,
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slideList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      userControl = true;
                    });
                  },
                  onHorizontalDragUpdate: (drag) {
                    setState(() {
                      userControl = true;
                    });

                    if (drag.primaryDelta! < 0) {
                      if (_currentPage != _slideList.length - 1) {
                        _pageController.nextPage(
                          duration: _slideAnimationDuration,
                          curve: Curves.easeIn,
                        );
                      }
                    } else {
                      if (_currentPage != 0) {
                        _pageController.previousPage(
                          duration: _slideAnimationDuration,
                          curve: Curves.easeIn,
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _slideList[index].image,
                        SizedBox(height: _currentPage == 0 ? 14 : 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            _slideList[index].title,
                            style: const TextStyle(
                                color: AppColors.darkBlueText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _slideList[index].subtitle,
                            style: const TextStyle(
                                color: AppColors.grey200,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (isLastPage)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: CustomAppTextFormField(
                              hintText: AppStrings.firstName,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SlideIndicator(
                    selectedIndex: _currentPage, slideList: _slideList),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: CustomAppButton(
                    onTap: () {
                      //set walkthrough seen
                      isLastPage
                          ? Navigation.navigateToScreen(
                              context: context,
                              screen: const NavigationHostPage(),
                            )
                          : _pageController.nextPage(
                              duration: _slideAnimationDuration,
                              curve: Curves.easeIn,
                            );
                    },
                    foregroundColor: Colors.white,
                    child: Text(
                        isLastPage ? AppStrings.continueText : AppStrings.next),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
