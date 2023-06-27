import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class DateScreen extends StatelessWidget {
  final MapEntry<String, List<Attendance>> mp;
  DateScreen(this.mp, {super.key});
  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: mp.key,
      child: Ui.padding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.thin(
                  "${mp.value[0].faculty!}\n${mp.value[0].course!}\n${mp.value[0].department!}\n",
                  color: AppColors.white40),
              AppText.thin(
                  controller.dateText(mp.value[0].fullname!, mp.value.length)),
              Ui.boxHeight(24),
              ...List.generate(
                  mp.value.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: AppText.thin(
                            "${index + 1})  ${mp.value[index].course!}"),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDateScreen extends StatelessWidget {
  final MapEntry<String, List<Attendance>> mp;
  AdminDateScreen(this.mp, {super.key});
  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: mp.key,
      child: Ui.padding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.thin(controller.adminDateText(mp.value.length)),
              ...List.generate(
                  mp.value.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: AppText.thin(
                            "${index + 1}) ${mp.value[index].fullname!}, ${mp.value[index].regNo!}"),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
