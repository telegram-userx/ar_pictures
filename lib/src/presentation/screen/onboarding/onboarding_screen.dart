import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../../generated/strings.g.dart';
import '../../../common/config/router/app_router.gr.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/extension/extensions.dart';
import '../../../data/data_source/shared_preferences/shared_preferences_helper.dart';
import '../../../service_locator/sl.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey _key = GlobalKey();

  int activePage = 0;
  bool isLastPage = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      sl<SharedPreferencesHelper>().setIsFirstAppLaunch(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _key,
      onChange: (value) => setState(() {
        activePage = value;

        isLastPage = activePage == 2;
      }),
      globalFooter: SizedBox(
        height: context.height * 0.12,
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 4,
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.24,
                vertical: AppConstants.padding * 1.6,
              ),
            ),
            onPressed: () {
              final pageController = (_key.currentState as IntroductionScreenState?)?.controller as PageController;

              if (isLastPage) {
                context.navigateTo(
                  const PhotoAlbumRoute(),
                );
              } else {
                pageController.animateToPage(
                  activePage + 1,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              (isLastPage
                      ? TranslationProvider.of(context).translations.start
                      : TranslationProvider.of(context).translations.next)
                  .toUpperCase(),
              style: context.textTheme.titleMedium?.copyWith(),
            ),
          ),
        ),
      ),
      showDoneButton: false,
      showNextButton: false,
      showBackButton: false,
      showSkipButton: false,
      pages: [
        PageViewModel(
          title: TranslationProvider.of(context).translations.welcome,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: TranslationProvider.of(context).translations.gozelAyStudio,
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: TranslationProvider.of(context).translations.qrCode,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: TranslationProvider.of(context).translations.qrCodeInfo,
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: TranslationProvider.of(context).translations.arPhoto,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: TranslationProvider.of(context).translations.arPhotoInfo,
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
      ],
    );
  }
}
