import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/app/theme/colors.dart';
import 'package:unn_attendance/src/features/home/views/widgets/loading_screen.dart';
import 'package:unn_attendance/src/global/controller/loading_controller.dart';
import 'package:unn_attendance/src/utils/constants/constant_barrel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/features/splashscreen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.black.withOpacity(0),
    statusBarIconBrightness: Brightness.dark,
  ));
  Get.put(LoadingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TAAMS',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'), // English
      ],
      theme: ThemeData(
        fontFamily: Assets.appFontFamily,
        scaffoldBackgroundColor: AppColors.primaryColor,
      ),
      home: LoadingScreen(child: SplashScreen()),
    );
  }
}
