import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/splashscreen/splash_screen.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../src_barrel.dart';

class HomeForScreen extends StatelessWidget {
  HomeForScreen({super.key});
  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Ui.padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return AppText.bold(
                              controller.currentUser.value!.regno,
                              fontSize: 24);
                        }),
                        Obx(() {
                          return AppText.medium(
                            controller.currentUser.value!.school.toUpperCase(),
                            fontSize: 20,
                          );
                        }),
                        Obx(() {
                          return AppText.medium(
                              controller.currentUser.value!.fullName,
                              fontSize: 15,
                              color: AppColors.white40);
                        }),
                        Obx(() {
                          return AppText.thin(
                              controller.currentUser.value!.email,
                              fontSize: 15,
                              color: AppColors.white40);
                        }),
                        Obx(() {
                          return AppText.thin(
                              controller.currentUser.value!.role.capitalize!,
                              fontSize: 15,
                              color: AppColors.white40);
                        })
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () async {
                        Get.offAll(SplashScreen());
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: AppColors.white,
                      ))
                ],
              ),
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.folder_off_rounded,
                      color: AppColors.accentColor,
                      size: 120,
                    ),
                    Ui.boxHeight(24),
                    AppText.bold("No Records found", fontSize: 24),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
