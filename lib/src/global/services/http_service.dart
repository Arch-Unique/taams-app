import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:unn_attendance/src/global/model/attendance.dart';
import 'package:unn_attendance/src/global/model/user.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/src_barrel.dart';

import 'myprefs.dart';

// import '../../src_barrel.dart';

class HttpService {
  static final _dio = Dio();
  static const String baseURI = "https://api.taams.com.ng/api";
  // static const String baseURI = "http://192.168.250.225:3050/api";

  static const String attendanceURI = "$baseURI/attendance";
  // static const String authcodeURI = "$baseURI/authcode";
  static const String userURI = "$baseURI/user";
  static const String appuserURI = "$baseURI/app";
  static const String schoolURI = "$baseURI/school";
  static const String staffURI = "$baseURI/staff";

  //querytype ==== course / regno / fdl
  static Future<List<Attendance>> getAttendance(
      {Map<String, String> query = const {},
      int fromDate = 0,
      int toDate = 33000000000000}) async {
    final nbody = {"input": query, "from": fromDate, "to": toDate};
    String uri = "$attendanceURI/query";

    try {
      print(nbody);
      final res = await _dio.post(uri,
          data: nbody,
          options: Options(headers: {
            "x-school-token": MyPrefs.readData(MyPrefs.mpSchool),
          }));

      if (res.statusCode == 200) {
        final c = res.data["data"];
        print(c);
        List<Attendance> g = [];
        for (Map<String, dynamic> item in c) {
          Attendance ref = Attendance.fromJSON(item);
          g.add(ref);
        }
        if (g.isEmpty) {
          Ui.showSnackBar("No Attendance Record found");
        }

        return g;
      } else {
        Ui.showSnackBar("An error occured, please try again later");
      }
      return [];
    } catch (e) {
      print(e);
      Ui.showSnackBar("An error occured, please try again later");

      return [];
    }
  }

  static Future<List<String>> getSchools() async {
    try {
      final res = await _dio.get(schoolURI);

      if (res.statusCode == 200) {
        final c = res.data;
        List<String> g = [];
        for (Map<String, dynamic> item in c) {
          g.add(item["school"]);
        }
        if (g.isEmpty) {
          Ui.showSnackBar("No Schools Found");
        }

        return g;
      } else {
        Ui.showSnackBar("An error occured, please try again later");
      }
      return [];
    } catch (e) {
      print(e);
      Ui.showSnackBar("An error occured, please try again later");

      return [];
    }
  }

  static Future<bool> login(int userType, String school, String user) async {
    String uri = "$userURI/app-login";

    try {
      final res = await _dio.post(uri,
          data: {"userType": userType, "school": school, "userName": user});

      if (res.statusCode == 200) {
        await MyPrefs.login(userType, school, user);
        return true;
      } else {
        Ui.showSnackBar("Invalid User");
        return false;
      }
    } catch (e) {
      print(e);
      // Ui.showSnackBar("User not found");

      return false;
    }
  }

  static Future<User?> applogin(
      String id, String password, String school) async {
    String uri = "$appuserURI/login";

    try {
      final res = await _dio.post(uri,
          data: {"username": id, "school": school, "password": password});

      if (res.statusCode == 200) {
        // await MyPrefs.login(res.data["role"], school, res.data["regno"]);
        return User.fromJson(res.data["data"]);
      } else {
        Ui.showSnackBar("Invalid User ID/Password");
        return null;
      }
    } catch (e) {
      print(e);
      Ui.showSnackBar("Invalid User ID/Password");

      return null;
    }
  }

  static Future<User?> appRegister(String id, String password, String school,
      String firstname, String surname, String role, String email) async {
    String uri = "$appuserURI/register";

    try {
      final res = await _dio.post(uri, data: {
        "regno": id,
        "schoolId": school,
        "password": password,
        "firstname": firstname,
        "surname": surname,
        "email": email,
        "role": role,
      });

      if (res.statusCode == 200) {
        // await MyPrefs.login(res.data["role"], school, res.data["regno"]);
        return User.fromJson(res.data["data"]);
      } else {
        Ui.showSnackBar("User already exist, Please try again");
        return null;
      }
    } catch (e) {
      print(e);
      Ui.showSnackBar("Error registering user");

      return null;
    }
  }

  static Future<bool> forgotPassword(String email) async {
    String uri = "$appuserURI/forgot-password";

    try {
      final res = await _dio.post(uri, data: {"email": email});
      print(res);
      if (res.statusCode == 200) {
        return true;
      } else {
        Ui.showSnackBar("Email does not exist");
        return false;
      }
    } catch (e) {
      print("yh");
      Ui.showSnackBar("Email does not exist");

      return false;
    }
  }

  static Future<List<String>> getCoursesByStaff(String id) async {
    String uri = "$staffURI/get-courses";
    print(id);

    try {
      final res = await _dio.post(uri,
          data: {"staffid": id},
          options: Options(headers: {
            "x-school-token": MyPrefs.readData(MyPrefs.mpSchool),
          }));

      if (res.statusCode == 200) {
        final c = res.data;
        List<String> g = [];
        for (Map<String, dynamic> item in c) {
          g.add(item["coursecode"]);
        }
        if (g.isEmpty) {
          Ui.showSnackBar("No Courses Found");
        }

        return g;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      Ui.showSnackBar("No courses found");

      return [];
    }
  }

  static Future<List<Attendance>> getAttendanceByRegNo(String query) async {
    return getAttendance(query: {
      "regno": query,
    }, toDate: DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<Attendance>> getAttendanceByCourse(String query) async {
    return getAttendance(query: {
      "course": query,
    }, toDate: DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<Attendance>> getAttendanceByName(String query) async {
    return getAttendance(query: {
      "fullname": query,
    }, toDate: DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<Attendance>> getAttendanceByFDL(
      String faculty, String dept, String level) async {
    return getAttendance(
        query: {"faculty": faculty, "department": dept, "level": level},
        toDate: DateTime.now().millisecondsSinceEpoch);
  }
}
