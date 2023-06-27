import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/services/http_service.dart';
import 'package:unn_attendance/src/global/services/myprefs.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/utils/enums/enum_barrel.dart';

class AppController extends GetxController {
  ///0 - filter
  List<TextEditingController> conts =
      List.generate(2, (index) => TextEditingController());

  final attendanceController = Get.find<AttendanceController>();
  RxString code = "".obs;

  ///User State
  ///0 - student
  ///1 - parent
  ///2 - lecturer
  RxInt userState = 3.obs;

  ///Home State
  ///0 - reg no
  ///1 - course
  ///2 - fdl
  RxInt homeState = 0.obs;
  RxString title = "".obs; //query
  RxString faculty = "".obs; //query
  RxString department = "".obs; //query
  RxString fullname = "".obs; //query
  RxString level = "".obs; //query
  RxInt curFilter = 0.obs;

  //Date
  static List<String> timeDetails = ["All Time", "Weekly", "Monthly"];
  // static List<String> homeTitle = ["Reg No", "Course", "Level"];

  String get titleValue {
    if (homeState.value == 0) {
      return "${fullname.value}\n${faculty.value}\n${department.value}";
    } else if (homeState.value == 1) {
      return "Course";
    }
    return "${faculty.value}\n${department.value}";
  }

  refreshHome() async {
    List<Attendance> sg = [];
    if (homeState.value == 0) {
      sg = await HttpService.getAttendanceByRegNo(title.value);
    } else if (homeState.value == 1) {
      sg = await HttpService.getAttendanceByCourse(title.value);
    } else {
      sg = await HttpService.getAttendanceByFDL(
          faculty.value, department.value, level.value);
    }
    attendanceController.setAttendanceList(sg);
  }

  // int _getFromDate() {
  //   if (curFilter.value == 0) {
  //     return 0;
  //   } else if (curFilter.value == 1) {
  //     return DateTime.now().millisecondsSinceEpoch - 604800000;
  //   } else {
  //     return DateTime.now().millisecondsSinceEpoch - 2592000000;
  //   }
  // }

  setTitle(String i) {
    title.value = i;
  }

  setUserState(int i) {
    userState.value = i;
  }

  setCurFilter(int i) {
    userState.value = i;
  }

  setHomeState(int i) {
    homeState.value = i;
  }

  String courseText(String name, int no) {
    return "$name attended this course for a total of $no times";
  }

  String courseText1(String course, List<String> dates) {
    return "$course held for a total of ${dates.length} times.\nThe dates are ${dates.join(", ")}\n";
  }

  String dateText(String name, int no) {
    return "$name attended $no courses on this particular day";
  }

  String adminDateText(int no) {
    return "$no students attended this course on this particular day";
  }

  setCode(String cd) {
    code.value = cd;
  }

  resetController() async {
    setTitle("");
    setCurFilter(0);
    setHomeState(0);
    setUserState(3);
    setCode("");
    attendanceController.allAttendance.value = [];
    await MyPrefs.logout();
  }
}
