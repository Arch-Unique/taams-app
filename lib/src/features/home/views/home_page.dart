import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unn_attendance/src/features/home/views/widgets/custom_dropdown.dart';
import 'package:unn_attendance/src/features/home/views/widgets/loading_screen.dart';
import 'package:unn_attendance/src/features/home/views/widgets/tables.dart';
import 'package:unn_attendance/src/features/splashscreen/splash_screen.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/src_barrel.dart';

import '../../../global/ui/ui_barrel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<AppController>();
  bool isRefreshing = false;
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      child: Scaffold(
        body: SafeArea(
          child: Ui.padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return WidgetOrNull(
                        controller.attendanceController.hasChanged.value,
                        child: IconButton(
                            onPressed: () async {
                              controller.setHomeState(2);
                              controller.setTitle(controller.level.value);
                              loadCont.showOverlay();
                              await controller.refreshHome();
                              controller.attendanceController
                                  .changeAttState(false);
                              controller.attendanceController.setModList([]);
                              loadCont.closeOverlay();
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: AppColors.white,
                            )),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return AppText.bold(
                                "${controller.title.value}${controller.homeState.value == 2 ? " LEVEL" : ""}",
                                fontSize: 24);
                          }),
                          Obx(() {
                            return AppText.thin(controller.titleValue,
                                fontSize: 15, color: AppColors.white40);
                          })
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: isRefreshing
                            ? null
                            : () async {
                                loadCont.showOverlay();
                                await controller.refreshHome();

                                loadCont.closeOverlay();
                              },
                        icon: Icon(
                          Icons.refresh,
                          color: AppColors.white,
                        )),
                    Ui.boxWidth(24),
                    IconButton(
                        onPressed: () async {
                          await controller.resetController();
                          Get.offAll(SplashScreen());
                        },
                        icon: Icon(
                          Icons.logout_rounded,
                          color: AppColors.white,
                        ))
                  ],
                ),
                if (controller.homeState.value == 1)
                  Align(
                      alignment: Alignment.centerRight,
                      child: isDownloading
                          ? AppText.thin("Getting Excel file ready...")
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isDownloading = true;
                                });
                                final excel = Excel.createExcel();
                                final course = controller
                                    .attendanceController.currAtts[0].course;
                                final sheet = excel['$course-AttendanceList'];

                                final courseDates = controller
                                    .attendanceController.currAtts[0].dates;
                                final header = [
                                  "S/N",
                                  "Reg No",
                                  "Full Name",
                                  "Level",
                                  "Department",
                                  "Faculty",
                                  "Attendance Rate",
                                ];
                                header.addAll(courseDates);
                                final atts =
                                    AttendanceController.getGroupedListByRegNo(
                                        controller
                                            .attendanceController.currAtts);
                                final attsRegNo = atts.keys.toList();

                                sheet.insertRowIterables(
                                    ["$course Attendance List"], 0);
                                sheet.insertRowIterables(header, 2);
                                for (var i = 0; i < atts.length; i++) {
                                  final userAtt = atts[attsRegNo[i]]![0];
                                  final userDates = atts[attsRegNo[i]]!
                                      .map((e) => e.date)
                                      .toList();
                                  sheet.insertRowIterables([
                                    i + 1,
                                    userAtt.regNo,
                                    userAtt.fullname,
                                    userAtt.level,
                                    userAtt.department,
                                    userAtt.faculty,
                                    ((atts[attsRegNo[i]]!.length /
                                                courseDates.length) *
                                            100)
                                        .toStringAsFixed(2),
                                    ...List.generate(courseDates.length,
                                        (index) {
                                      return userDates
                                              .contains(courseDates[index])
                                          ? "✔"
                                          : "x";
                                    })
                                  ], i + 3);
                                }
                                final fileBytes = excel.save();
                                final directory =
                                    await getApplicationDocumentsDirectory();

                                final file = File(join(
                                    '${directory.path}/${course}_attendance_list.xlsx'))
                                  ..createSync(recursive: true)
                                  ..writeAsBytesSync(fileBytes!);

                                await Share.shareXFiles([XFile(file.path)]);
                                setState(() {
                                  isDownloading = false;
                                });
                              },
                              icon: Icon(
                                Icons.download,
                                color: AppColors.white,
                              ))),
                // CDropDown(
                //     AppController.timeDetails,
                //     controller.conts[0],
                //     isRefreshing
                //         ? () {}
                //         : () async {
                //             final i = AppController.timeDetails
                //                 .indexOf(controller.conts[0].value.text);

                //             controller.setCurFilter(i);
                //             setState(() {
                //               isRefreshing = true;
                //             });
                //             await controller.refreshHome();
                //             setState(() {
                //               isRefreshing = false;
                //             });
                //           }),
                isRefreshing
                    ? Expanded(child: Center(child: CircularProgress(48)))
                    : Obx(() {
                        return chooseHomeStateWidget(
                            controller.homeState.value);
                      })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseHomeStateWidget(int i) {
    Widget c;
    if (i == 0) {
      c = UserTable(controller.attendanceController.currAtts);
    } else if (i == 1) {
      c = CourseTable(controller.attendanceController.currAtts);
    } else {
      c = AllDataTable(controller.attendanceController.allAttendance);
    }
    return Expanded(child: c);
  }
}
