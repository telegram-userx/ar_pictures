import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/strings.g.dart';
import '../../common/config/router/app_router.gr.dart';
import '../../common/constant/app_constants.dart';
import '../../common/extension/extensions.dart';
import '../../service_locator/sl.dart';
import '../../common/widget/space.dart';
import '../../data/data_source/local/shared_preferences/shared_preferences_helper.dart';

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
      globalHeader: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Space.v20,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding * 2),
              child: Row(
                children: [
                  _ThemeSwitcher(),
                  const Spacer(),
                  _LanguageSelector(),
                ],
              ),
            ),
          ],
        ),
      ),
      onChange: (value) => setState(() {
        activePage = value;

        isLastPage = activePage == 2;
      }),
      bodyPadding: const EdgeInsets.only(top: kToolbarHeight),
      globalFooter: SizedBox(
        height: context.height * 0.12,
        child: Center(
          child: FilledButton(
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
                  const QrScannerRoute(),
                );
              } else {
                pageController.animateToPage(
                  activePage + 1,
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: SizedBox(
              width: context.width * 0.2,
              child: Text(
                (isLastPage ? context.translations.start : context.translations.next).toUpperCase(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        activeColor: context.colorScheme.primary,
      ),
      showDoneButton: false,
      showNextButton: false,
      showBackButton: false,
      showSkipButton: false,
      pages: [
        PageViewModel(
          title: context.translations.welcome,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: context.translations.gozelAyStudio,
          image: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Container(
              color: AdaptiveTheme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white,
              height: context.height * 0.3,
              child: Image.asset(
                'assets/images/app_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        PageViewModel(
          title: context.translations.qrCode,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: context.translations.qrCodeInfo,
          image: Container(
            padding: const EdgeInsets.all(AppConstants.padding),
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            height: context.height * 0.3,
            child: Lottie.asset(
              'assets/lottie/qr_code.json',
            ),
          ),
        ),
        PageViewModel(
          title: context.translations.arPhoto,
          decoration: PageDecoration(
            titleTextStyle: context.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppConstants.fontSizeH1 * 2,
            ),
            bodyTextStyle: context.textTheme.titleLarge!,
          ),
          body: context.translations.arPhotoInfo,
          image: Container(
            padding: const EdgeInsets.all(AppConstants.padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              color: AdaptiveTheme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white,
            ),
            height: context.height * 0.3,
            child: Lottie.asset(
              'assets/lottie/scan_your_face.json',
              repeat: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 45,
      child: IconButton.filled(
        style: IconButton.styleFrom(
          elevation: 8,
        ),
        onPressed: () {
          AdaptiveTheme.of(context).toggleThemeMode();
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          child: AdaptiveTheme.of(context).brightness == Brightness.dark
              ? const Icon(
                  Icons.light_mode,
                )
              : const Icon(
                  Icons.dark_mode,
                ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Material(
        type: MaterialType.button,
        elevation: 4,
        color: context.theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(90),
        ),
        child: PopupMenuButton<AppLocale>(
          onSelected: LocaleSettings.setLocale,
          tooltip: '',
          constraints: const BoxConstraints(
            maxWidth: 45,
          ),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(90),
          ),
          itemBuilder: (BuildContext context) {
            return AppLocale.values.map((value) {
              final selectedValue = TranslationProvider.of(context).locale;

              return PopupMenuItem<AppLocale>(
                value: value,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: value == selectedValue ? context.theme.colorScheme.primary : null,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(
                    value.languageTag,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: value == selectedValue ? context.theme.colorScheme.onPrimary : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            margin: EdgeInsets.zero,
            alignment: Alignment.center,
            child: Text(
              TranslationProvider.of(context).locale.languageTag,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
