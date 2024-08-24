import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../common/config/router/app_router.gr.dart';
import '../../../data/data_source/shared_preferences/shared_preferences_helper.dart';
import '../../../service_locator/sl.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
      done: const Icon(
        CupertinoIcons.chevron_right,
      ),
      onDone: () {
        context.navigateTo(
          const PhotoAlbumRoute(),
        );
      },
      next: const Icon(
        CupertinoIcons.chevron_right,
      ),
      back: const Icon(
        CupertinoIcons.chevron_left,
      ),
      skip: const Icon(
        Icons.skip_next,
      ),
      onSkip: () {
        context.navigateTo(
          const PhotoAlbumRoute(),
        );
      },
      pages: [
        PageViewModel(
          title: "Title of introduction page",
          body: "Welcome to the app! This is a description of how it works.",
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: "Title of introduction page",
          body: "Welcome to the app! This is a description of how it works.",
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
        PageViewModel(
          title: "Title of introduction page",
          body: "Welcome to the app! This is a description of how it works.",
          image: const Center(
            child: Icon(Icons.waving_hand, size: 50.0),
          ),
        ),
      ],
    );
  }
}
