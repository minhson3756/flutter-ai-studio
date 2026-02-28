// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LanguageScreen]
class LanguageRoute extends PageRouteInfo<LanguageRouteArgs> {
  LanguageRoute({Key? key, bool isFirst = false, List<PageRouteInfo>? children})
    : super(
        LanguageRoute.name,
        args: LanguageRouteArgs(key: key, isFirst: isFirst),
        initialChildren: children,
      );

  static const String name = 'LanguageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LanguageRouteArgs>(
        orElse: () => const LanguageRouteArgs(),
      );
      return WrappedRoute(
        child: LanguageScreen(key: args.key, isFirst: args.isFirst),
      );
    },
  );
}

class LanguageRouteArgs {
  const LanguageRouteArgs({this.key, this.isFirst = false});

  final Key? key;

  final bool isFirst;

  @override
  String toString() {
    return 'LanguageRouteArgs{key: $key, isFirst: $isFirst}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LanguageRouteArgs) return false;
    return key == other.key && isFirst == other.isFirst;
  }

  @override
  int get hashCode => key.hashCode ^ isFirst.hashCode;
}

/// generated route for
/// [OnBoardingScreen]
class OnBoardingRoute extends PageRouteInfo<OnBoardingRouteArgs> {
  OnBoardingRoute({
    Key? key,
    bool fromSplash = false,
    List<PageRouteInfo>? children,
  }) : super(
         OnBoardingRoute.name,
         args: OnBoardingRouteArgs(key: key, fromSplash: fromSplash),
         initialChildren: children,
       );

  static const String name = 'OnBoardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnBoardingRouteArgs>(
        orElse: () => const OnBoardingRouteArgs(),
      );
      return WrappedRoute(
        child: OnBoardingScreen(key: args.key, fromSplash: args.fromSplash),
      );
    },
  );
}

class OnBoardingRouteArgs {
  const OnBoardingRouteArgs({this.key, this.fromSplash = false});

  final Key? key;

  final bool fromSplash;

  @override
  String toString() {
    return 'OnBoardingRouteArgs{key: $key, fromSplash: $fromSplash}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnBoardingRouteArgs) return false;
    return key == other.key && fromSplash == other.fromSplash;
  }

  @override
  int get hashCode => key.hashCode ^ fromSplash.hashCode;
}

/// generated route for
/// [SettingScreen]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}
