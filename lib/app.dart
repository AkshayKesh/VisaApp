import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; // Import responsive_sizer
import 'package:toastification/toastification.dart';

import 'core/constants/dark_theme.dart';
import 'core/constants/light_theme.dart';
import 'core/constants/router/navigation_router.dart';

/// Global navigator key for accessing BuildContext at a global level.
/// Use `globalNavigatorKey.currentContext` where a BuildContext is normally required, even outside the widget tree.
///
/// Example usage (such as in app_toast.dart):
///   toastification.show(
///     context: globalNavigatorKey.currentContext,
///     ...
///   );
///
/// Also reference this key in your MaterialApp:
///   navigatorKey: globalNavigatorKey,
final GlobalKey<NavigatorState> globalNavigatorKey =
    GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return ToastificationWrapper(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Register Visa Application',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              routerConfig: NavigationRouter.router,
            ),
          );
        },
      ),
    );
  }
}
