import 'dart:convert';

import 'package:intl/intl.dart';

class Attendance {
  String? regNo, course, faculty, department, level, fullname;
  int? rawDate;
  List<String> dates;

  Attendance(
      {this.regNo,
      this.rawDate,
      this.course,
      this.faculty,
      this.department,
      this.level,
      this.dates = const [],
      this.fullname});

  String get date =>
      getDateString(DateTime.fromMillisecondsSinceEpoch(rawDate!));

  String getDateString(DateTime dt) {
    return DateFormat("EEE, dd/MM/yyyy").format(dt);
  }

  factory Attendance.fromJSON(Map<String, dynamic> json) {
    final cdate = jsonDecode(json["Course.coursedates"]).map<String>((e) {
      return DateFormat("EEE, dd/MM/yyyy").format(DateTime.parse(e));
    }).toList();
    return Attendance(
        regNo: json["Student.regno"],
        rawDate: DateTime.parse(json["createdAt"]).millisecondsSinceEpoch,
        faculty: json["Student.faculty"],
        department: json["Student.department"],
        level: json["Student.level"],
        fullname: json["Student.surname"] + " " + json["Student.firstname"],
        course: json["Course.coursecode"],
        dates: cdate);
  }
}
