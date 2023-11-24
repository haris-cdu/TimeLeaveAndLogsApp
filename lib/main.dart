import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:employee_timesheet/constants/responsive.dart';
import 'package:employee_timesheet/pages/timesheet_page.dart';
import 'package:employee_timesheet/provider/graphdata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<GraphDataProvider>(
        create: (_) => GraphDataProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TimeSheet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: AnimatedSplashScreen(
            duration: 3500,
            splash: Image.asset("assets/splash_png.png",
                height: hp(context, 50), width: wp(context, 50)),
            splashIconSize: 200,
            nextScreen: const TimeSheetPage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }
}
