import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/home/views/course_screen.dart';
import 'package:unn_attendance/src/features/home/views/date_screen.dart';
import 'package:unn_attendance/src/features/home/views/home_page.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.find<AppController>();
  TextEditingController cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Search",
      child: Ui.padding(
        child: Column(children: [
          CustomTextField(
            getTitle(),
            "",
            cont,
            isLabel: false,
            suffix: Icons.search_rounded,
            suffixColor: AppColors.white,
            autofocus: true,
          ),
          const Spacer(),
          FilledButton.white(() {
            proceed();
          }, "Next")
        ]),
      ),
    );
  }

  String getTitle() {
    switch (controller.homeState.value) {
      case 0:
        return "Search Course";
      case 1:
        return "Search Reg No and Name Only";
      case 2:
        return "Search Reg No,Name and Course";
    }
    return "Search";
  }

  proceed() {
    String msg = "Not Found";
    String query = cont.value.text;
    switch (controller.homeState.value) {
      case 0:
        findCourse(query, msg);
        break;
      case 1:
        if (query.contains("/")) {
          findUserByRegNo(query, msg);
        } else {
          findUserByName(query, msg);
        }

        break;
      case 2:
        if (query.contains("/")) {
          final l = controller.attendanceController.getUserAttendance(query);
          if (l.isEmpty) {
            Ui.showSnackBar(msg);
            break;
          }
          controller.attendanceController.setModList(l);
          controller.fullname.value = l[0].fullname!;
          controller.setHomeState(0);
          controller.setTitle(query);
        } else if (query.contains(" ")) {
          final l =
              controller.attendanceController.getUserAttendanceByName(query);

          if (l.isEmpty) {
            Ui.showSnackBar(msg);
            break;
          }
          final g = AttendanceController.getGroupedListByName(l);

          Ui.showBottomSheet(
              children: List.generate(
                  g.length,
                  (index) => ListTile(
                        title: AppText.bold(g.entries.toList()[index].key),
                        onTap: () {
                          controller.attendanceController
                              .setModList(g.entries.toList()[index].value);
                          controller.fullname.value =
                              g.entries.toList()[index].key;
                          controller.setHomeState(0);
                          controller.setTitle(
                              g.entries.toList()[index].value[0].regNo!);
                        },
                      )));
        } else {
          final l =
              controller.attendanceController.getUserAttendanceByCourse(query);
          if (l.isEmpty) {
            Ui.showSnackBar(msg);
            break;
          }
          controller.attendanceController.setModList(l);
          controller.setHomeState(1);
          controller.setTitle(query);
        }

        controller.attendanceController.changeAttState(true);
        Get.to(HomeScreen());
        break;
    }
  }

  void findCourse(String query, String msg) {
    final l = controller.attendanceController.getUserAttendanceByCourse(query);

    if (l.isEmpty) {
      Ui.showSnackBar(msg);
    } else {
      Get.to(DateScreen(MapEntry(query, l)));
    }
  }

  void findUserByName(String query, String msg) {
    final l = controller.attendanceController.getUserAttendanceByName(query);

    if (l.isEmpty) {
      Ui.showSnackBar(msg);
    } else {
      final g = AttendanceController.getGroupedListByName(l);
      Ui.showBottomSheet(
          children: List.generate(
              g.length,
              (index) => ListTile(
                    title: AppText.bold(g.entries.toList()[index].key),
                    onTap: () {
                      Get.to(CourseScreen(MapEntry(
                          g.entries.toList()[index].value[0].regNo!,
                          g.entries.toList()[index].value)));
                    },
                  )));
    }
  }

  void findUserByRegNo(String query, String msg) {
    final l = controller.attendanceController.getUserAttendance(query);

    if (l.isEmpty) {
      Ui.showSnackBar(msg);
    } else {
      Get.to(CourseScreen(MapEntry(query, l)));
    }
  }
}
