import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/global/controller/loading_controller.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/others.dart';
import 'package:unn_attendance/src/src_barrel.dart';

class LoadingScreen extends StatefulWidget {
  final Widget child;
  const LoadingScreen({required this.child, super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final controller = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // SizedBox.expand(),
        widget.child,
        Obx(() {
          return controller.show.value
              ? Material(
                  color: AppColors.black.withOpacity(0.8),
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Container(
                          height: 144,
                          color: AppColors.accentColor.withOpacity(0.2),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgress(48),
                                Ui.boxHeight(24),
                                AppText.bold("Checking for network...")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox();
        })
      ],
    );
  }
}
