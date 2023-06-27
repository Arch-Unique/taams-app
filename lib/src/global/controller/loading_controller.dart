import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';

class LoadingController extends GetxController {
  RxBool show = false.obs;

  @override
  onInit() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        Ui.showSnackBar("No Network Detected");
        showOverlay();
      } else {
        closeOverlay();
      }
    });
    super.onInit();
  }

  showOverlay() {
    show.value = true;
  }

  closeOverlay() {
    show.value = false;
  }
}
