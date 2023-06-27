import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/home/views/home_for_page.dart';
import 'package:unn_attendance/src/features/home/views/home_page.dart';
import 'package:unn_attendance/src/features/registration/views/admin_login_screen.dart';
import 'package:unn_attendance/src/global/controller/app_controller.dart';
import 'package:unn_attendance/src/global/controller/attendance_controller.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/model/user.dart';
import 'package:unn_attendance/src/global/services/http_service.dart';
import 'package:unn_attendance/src/global/services/myprefs.dart';
import 'package:unn_attendance/src/global/ui/functions/ui_functions.dart';
import 'package:unn_attendance/src/src_barrel.dart';

class RegistrationController extends GetxController {
  /// TextEditingControllers
  /// 1 - Student Reg No
  /// 2 - Password
  /// 3 - Faculty
  /// 4 - Department
  /// 5 - Level
  /// 6 - Course
  /// 7 - type
  /// 8 - firstname
  /// 9 - surname
  /// 10 - role
  /// 11 - email
  /// 12 - cpass
  /// 13 - fpass
  /// TETFUND ASSISTED ATTENDANCE MANAGEMENT SYSTEM (TAAMS)
  List<TextEditingController> textControllers =
      List.generate(14, (index) => TextEditingController());
  var formkey = GlobalKey<FormState>();
  RxString fac = "Agriculture".obs;
  RxList<String> schools = <String>[].obs;
  RxList<String> courses = <String>[].obs;

  RxInt loginState = 0.obs;
  final List<String> loginStates = [
    "Course",
    "Level",
  ];
  var pformkey = GlobalKey<FormState>();
  final attendanceController = Get.find<AttendanceController>();
  final appController = Get.find<AppController>();

  bool get isCourse => loginState.value == 0;
  Rx<User?> currentUser = Rx<User?>(null);

  changeLoginState(int i) {
    loginState.value = i;
  }

  changeFAC(String i) {
    fac.value = i;
  }

  bool isLecturer(int i) {
    return i == 2;
  }

  /// Type
  /// 0 - student
  /// 2 - admin
  /// 1 - guardian
  Future login() async {
    int i = 0;
    switch (currentUser.value!.role) {
      case "lecturer":
        i = 2;
        break;
      case "guardian":
        i = 1;
        break;
      case "student":
        i = 0;
        break;
      default:
    }
    appController.setUserState(i);

    final isCorrectCode = await HttpService.login(
        i, currentUser.value!.school, currentUser.value!.regno);
    if (!isCorrectCode) {
      Get.offAll(HomeForScreen());
      _reset();
      return;
    }

    //Login
    if (i != 2) {
      //login as Student
      final att = await setAppForRegNo(currentUser.value!.regno);

      if (att.isNotEmpty) {
        Get.offAll(HomeScreen());
        _reset();
      }
    } else {
      courses.value =
          await HttpService.getCoursesByStaff(currentUser.value!.regno);
      Get.to(AdminLoginScreen());
    }
  }

  Future<void> onAppAuth(bool isLogin) async {
    final form = formkey.currentState!;
    if (form.validate()) {
      if (isLogin) {
        currentUser.value = await HttpService.applogin(
            textControllers[1].value.text,
            textControllers[2].value.text,
            textControllers[0].value.text);
      } else {
        currentUser.value = await HttpService.appRegister(
            textControllers[1].value.text,
            textControllers[2].value.text,
            textControllers[0].value.text,
            textControllers[8].value.text,
            textControllers[9].value.text,
            textControllers[10].value.text.toLowerCase(),
            textControllers[11].value.text);
      }
      if (currentUser.value != null) {
        await login();
      } else {
        _reset();
      }
    }
  }

  Future<void> onForgotPassword() async {
    if (textControllers[13].value.text.isEmail) {
      final a =
          await HttpService.forgotPassword(textControllers[13].value.text);
      if (a) {
        Ui.showSnackBar("Please check your email/spam inbox for the next steps",
            isError: false);
      }
    } else {
      Ui.showSnackBar("Invalid Email");
    }
  }

  Future<List<Attendance>> setAppForRegNo(String a) async {
    final att = await HttpService.getAttendanceByRegNo(a);
    if (att.isEmpty) return [];
    attendanceController.setAttendanceList(att);
    appController.faculty.value = att[0].faculty!;
    appController.fullname.value = att[0].fullname!;
    appController.department.value = att[0].department!;
    appController.level.value = att[0].level!;
    appController.setTitle(a);
    await MyPrefs.writeData(MyPrefs.mpRegno, a);
    return att;
  }

  getSchools() async {
    schools.value = await HttpService.getSchools();
  }

  Future loginAdmin() async {
    final form = pformkey.currentState!;
    if (form.validate()) {
      //Verify Phone
      appController.setUserState(2);
      List<Attendance> att = [];
      if (loginState.value == 0) {
        att = await setAppForCourse(textControllers[5].value.text);
      } else {
        att = await setAppForFDL(textControllers[2].value.text,
            textControllers[3].value.text, textControllers[4].value.text);
      }
      if (att.isNotEmpty) {
        Get.offAll(HomeScreen());
        _reset();
      }
    }
  }

  Future<List<Attendance>> setAppForCourse(String a) async {
    final att = await HttpService.getAttendanceByCourse(a);
    if (att.isEmpty) return [];
    attendanceController.setAttendanceList(att);
    appController.faculty.value = att[0].faculty!;
    appController.department.value = att[0].department!;
    appController.level.value = att[0].level!;
    appController.setHomeState(1);
    appController.setTitle(a);
    await MyPrefs.writeData(MyPrefs.mpCourse, a);
    return att;
  }

  Future<List<Attendance>> setAppForFDL(String a, String b, String c) async {
    final att = await HttpService.getAttendanceByFDL(a, b, c);
    if (att.isEmpty) return [];
    attendanceController.setAttendanceList(att);
    appController.faculty.value = a;
    appController.department.value = b;
    appController.level.value = c;
    appController.setHomeState(2);
    appController.setTitle(c);
    await MyPrefs.writeData(MyPrefs.mpFaculty, a);
    await MyPrefs.writeData(MyPrefs.mpDept, b);
    await MyPrefs.writeData(MyPrefs.mpLevel, c);
    return att;
  }

  _reset() {
    UtilFunctions.clearTextEditingControllers(textControllers);
    changeLoginState(0);
  }
}
