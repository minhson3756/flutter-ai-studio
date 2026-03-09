import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/di/di.dart';
import '../config/navigation/app_router.dart';
import '../config/observer/route_observer.dart';
import '../config/theme/light/light_theme.dart';
import '../gen/l18n/app_localizations.dart';
import '../shared/cubit/ad_visibility_cubit.dart';
import '../shared/cubit/language_cubit.dart';
import '../shared/cubit/rate_status_cubit.dart';
import '../shared/enum/language.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => AdVisibilityCubit(),
        ),
        BlocProvider(
          create: (context) => RateStatusCubit(),
        ),
      ],
      child: ScreenUtilInit(
        // TODO(all): Change designSize to your design size
        designSize: const Size(360, 800),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (context, child) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: const BodyApp(),
        ),
      ),
    );
  }
}

class BodyApp extends StatelessWidget {
  const BodyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Language?>(
      builder: (context, state) {
        return MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state?.locale,
          debugShowCheckedModeBanner: false,
          theme: lightThemeData,
          routerConfig: getIt<AppRouter>().config(
            navigatorObservers: () => [MainRouteObserver()],
          ),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
