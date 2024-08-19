// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ar_pictures/src/presentation/screen/ar_js_web_view_screen/ar_js_web_view_screen.dart'
    as _i1;
import 'package:ar_pictures/src/presentation/screen/onboarding/onboarding_screen.dart'
    as _i2;
import 'package:ar_pictures/src/presentation/screen/photo_album/photo_album_screen.dart'
    as _i3;
import 'package:auto_route/auto_route.dart' as _i4;

/// generated route for
/// [_i1.ArJsWebViewScreen]
class ArJsWebViewRoute extends _i4.PageRouteInfo<void> {
  const ArJsWebViewRoute({List<_i4.PageRouteInfo>? children})
      : super(
          ArJsWebViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'ArJsWebViewRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.ArJsWebViewScreen();
    },
  );
}

/// generated route for
/// [_i2.OnboardingScreen]
class OnboardingRoute extends _i4.PageRouteInfo<void> {
  const OnboardingRoute({List<_i4.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i3.PhotoAlbumScreen]
class PhotoAlbumRoute extends _i4.PageRouteInfo<void> {
  const PhotoAlbumRoute({List<_i4.PageRouteInfo>? children})
      : super(
          PhotoAlbumRoute.name,
          initialChildren: children,
        );

  static const String name = 'PhotoAlbumRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.PhotoAlbumScreen();
    },
  );
}
