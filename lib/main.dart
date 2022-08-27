import 'package:driklink/auth_provider.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ensureInitializedawait Firebase.initializeApp();
  await Prefs.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
    // runApp( MyApp()

    // EasyLocalization(
    //   child: MyApp(),
    //   supportedLocales: [
    //     Locale('en', 'US'),
    //     //Locale('de', 'DE'),
    //     //Locale('ar', 'DZ'),
    //     Locale('es', 'ES'),
    //     Locale('it', 'IT'),
    //     Locale('pt', 'PT'),
    //     //Locale('fr', 'FR'),
    //   ],
    //   path: 'assets/languages',
    // ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ResponsiveWrapper.builder(
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          ),
        );
      },
      title: 'Drinklink',
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      //localizationsDelegates: [
      // GlobalMaterialLocalizations.delegate,
      // GlobalWidgetsLocalizations.delegate,
      // GlobalCupertinoLocalizations.delegate,
      // DefaultCupertinoLocalizations.delegate,
      // EasyLocalization.of(context).delegate,
      //],
      // supportedLocales: EasyLocalization.of(context).supportedLocales,
      // locale: EasyLocalization.of(context).locale,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
