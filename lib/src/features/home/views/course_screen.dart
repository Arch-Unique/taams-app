import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';
import 'package:unn_attendance/src/src_barrel.dart';

class CourseScreen extends StatelessWidget {
  final MapEntry<String, List<Attendance>> mp;
  CourseScreen(this.mp, {super.key});
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
              AppText.thin(controller.courseText1(
                  mp.value[0].course!, mp.value[0].dates)),
              AppText.thin(controller.courseText(
                  mp.value[0].fullname!, mp.value.length)),
              AppText.bold(
                  "Attendance Rate : ${((mp.value.length / mp.value[0].dates.length) * 100).toStringAsFixed(2)}%"),
              ...List.generate(
                  mp.value.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: AppText.thin(
                            "${index + 1})  ${mp.value[index].date}"),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
