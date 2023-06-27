import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/utils/enums/enum_barrel.dart';

class AttendanceController extends GetxController {
  RxList<Attendance> allAttendance = <Attendance>[].obs;
  RxList<Attendance> modAtts = <Attendance>[].obs;

  RxList<Attendance> get currAtts => modAtts.isEmpty ? allAttendance : modAtts;
  RxBool hasChanged = false.obs;

  changeAttState(bool i) {
    hasChanged.value = i;
  }

  setAttendanceList(List<Attendance> allAtt) {
    allAttendance.value = allAtt;
    _sortByDate();
  }

  setModList(List<Attendance> allAtt) {
    modAtts.value = allAtt;
  }

  //get user's attendance by regno
  List<Attendance> getUserAttendance(String regno) {
    return allAttendance.where((element) => element.regNo == regno).toList();
  }

  //get user's attendance by name
  List<Attendance> getUserAttendanceByName(String name) {
    return allAttendance
        .where((element) =>
            element.fullname!.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  //get user's attendance by course
  List<Attendance> getUserAttendanceByCourse(String course) {
    return allAttendance
        .where(
            (element) => element.course!.toLowerCase() == course.toLowerCase())
        .toList();
  }

  //get user's attendance by date
  List<Attendance> getUserAttendanceByDate(int date) {
    return allAttendance.where((element) => element.rawDate == date).toList();
  }

  _sortByDate() {
    allAttendance.sort(((a, b) => a.rawDate!.compareTo(b.rawDate!)));
  }

  static Map<String, List<Attendance>> getGroupedListByDate(
      List<Attendance> soms) {
    final groupedInbox = groupBy(soms, (Attendance ele) {
      return ele.date;
    });
    return groupedInbox;
  }

  static Map<String, List<Attendance>> getGroupedListByCourse(
      List<Attendance> soms) {
    final groupedInbox = groupBy(soms, (Attendance ele) {
      return ele.course!;
    });
    return groupedInbox;
  }

  static Map<String, List<Attendance>> getGroupedListByRegNo(
      List<Attendance> soms) {
    final groupedInbox = groupBy(soms, (Attendance ele) {
      return ele.regNo!;
    });
    return groupedInbox;
  }

  static Map<String, List<Attendance>> getGroupedListByName(
      List<Attendance> soms) {
    final groupedInbox = groupBy(soms, (Attendance ele) {
      return ele.fullname!;
    });
    return groupedInbox;
  }
}
