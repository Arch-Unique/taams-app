import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/home/views/home_page.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/registration/views/login_screen.dart';
import 'package:unn_attendance/src/features/registration/views/registration_screen.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/services/myprefs.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';

import '../../src_barrel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  injectDependencies() {
    Get.put(AttendanceController());
    Get.put(AppController());
    Get.put(RegistrationController());
  }

  bool isLoading = true;

  @override
  void initState() {
    injectDependencies();
    checkIfLoggedIn();
    super.initState();
  }

  Future<void> checkIfLoggedIn() async {
    final controller = Get.find<RegistrationController>();
    if (MyPrefs.isLoggedIn()) {
      final regno = MyPrefs.readData(MyPrefs.mpRegno);
      final course = MyPrefs.readData(MyPrefs.mpCourse);
      if (regno != "") {
        await controller.setAppForRegNo(regno);
      } else if (course != "") {
        await controller.setAppForCourse(course);
      } else {
        await controller.setAppForFDL(
            MyPrefs.readData(MyPrefs.mpFaculty),
            MyPrefs.readData(MyPrefs.mpDept),
            MyPrefs.readData(MyPrefs.mpLevel));
      }
      Get.offAll(HomeScreen());
    } else {
      await controller.getSchools();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: SafeArea(
        child: Ui.padding(
          padding: 32,
          child: FadeAnimWidget(
            fadeIn: true,
            child: isLoading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgress(24),
                      Ui.boxHeight(24),
                      AppText.bold("Getting Schools")
                    ],
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ui.boxHeight(64),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.bold("TETFUND ",
                              color: AppColors.accentColor, fontSize: 36),
                          AppText.medium("Assisted", fontSize: 36)
                        ],
                      ),
                      AppText.medium("Attendance \nManagement System",
                          fontSize: 36),
                      AppText.medium("(TAAMS)", fontSize: 36),
                      Ui.boxHeight(8),
                      AppText.thin("Attendance checking made easy"),
                      const Spacer(),
                      Ui.align(
                        align: Alignment.center,
                        child: Image.asset(Assets.logoj),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.outline(() {
                              Get.to(RegisterationScreen());
                            }, "Register"),
                          ),
                          Ui.boxWidth(32),
                          Expanded(
                            child: FilledButton.outline(() {
                              Get.to(LoginScreen());
                            }, "Login"),
                          )
                        ],
                      ),
                      Ui.boxHeight(32),
                      // FilledButton.white(() {
                      //   Get.to(LoginScreen(1));
                      // }, "Guardian")
                    ],
                  ),
          ),
        ),
      ),
    ));
  }
}
