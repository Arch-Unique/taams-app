import 'package:get_storage/get_storage.dart';

class MyPrefs {
  static const String mpUserType = "mpUserType";
  static const String mpUser = "mpUser";
  static const String mpRegno = "mpRegno";
  static const String mpSchool = "mpSchool";
  static const String mpCourse = "mpCourse";
  static const String mpFaculty = "mpFaculty";
  static const String mpDept = "mpDept";
  static const String mpLevel = "mpLevel";
  static const String mpIsLoggedIn = "mpIsLoggedIn";

  static final _prefs = GetStorage();

  static Future<void> writeData(String key, String value) async {
    await _prefs.write(key, value);
  }

  static String readData(String key) {
    return _prefs.read(key) ?? "";
  }

  static bool readBool(String key) {
    return _prefs.read(key);
  }

  static Future<bool> login(int userType, String school, String user) async {
    await _prefs.write(mpUserType, userType);
    await _prefs.write(mpSchool, school);
    await _prefs.write(mpUser, user);
    await _prefs.write(mpIsLoggedIn, true);
    return true;
  }

  static bool isLoggedIn() {
    return _prefs.read(mpIsLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    await eraseAllExcept("");
  }

  static eraseAllExcept(String key) async {
    final allKeys = List.from(_prefs.getKeys());
    for (var element in allKeys) {
      if (element == key) continue;
      await _prefs.remove(element);
    }
  }
}
