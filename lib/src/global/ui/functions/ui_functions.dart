import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';
import '../ui_barrel.dart';
import '/src/app/app_barrel.dart';
import '/src/utils/utils_barrel.dart';

abstract class Ui {
  static SizedBox boxHeight(double height) => SizedBox(height: height);

  static SizedBox boxWidth(double width) => SizedBox(width: width);

  ///All padding
  static Padding padding({Widget? child, double padding = 24}) => Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      );

  static Align align({Widget? child, Alignment align = Alignment.centerLeft}) =>
      Align(
        alignment: align,
        child: child,
      );

  static BorderRadius circularRadius(double radius) => BorderRadius.all(
        Radius.circular(radius),
      );

  static BorderRadius topRadius(double radius) => BorderRadius.vertical(
        top: Radius.circular(radius),
      );

  static BorderRadius bottomRadius(double radius) => BorderRadius.vertical(
        bottom: Radius.circular(radius),
      );

  static BorderSide simpleBorderSide({Color color = AppColors.grey}) =>
      BorderSide(
        color: color,
        width: 1,
      );

  static Scrollbar scrollbBar({required Widget child}) {
    return Scrollbar(radius: Radius.circular(8), child: child);
  }

  static showSnackBar(
    String message, {
    bool isError = true,
  }) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      icon: Icon(
        isError ? Icons.warning : Icons.check_rounded,
        size: 16,
        color: isError ? AppColors.red : AppColors.green,
      ),
      backgroundColor: AppColors.secondaryColor,
      borderRadius: 16,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.only(left: 24, right: 24, bottom: Get.height / 6),
    ));
  }

  static showBottomSheet({
    VoidCallback? yesBtn,
    List<Widget>? children,
    Widget? backWidget,
    String? title,
    String? message,
  }) {
    Get.bottomSheet(
        Ui.padding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children ??
                [
                  Row(
                    children: [
                      AppText.medium(title ?? "", fontSize: 24),
                      const Spacer(),
                      SvgIconButton(
                        Assets.close,
                        () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                  Ui.boxHeight(16),
                  AppText.thin(message ?? ""),
                  Ui.boxHeight(24),
                  Row(
                    children: [
                      Expanded(
                          child: FilledButton.outline(() {
                        Get.back();
                      }, "No", color: AppColors.secondaryColor)),
                      Ui.boxWidth(16),
                      Expanded(
                          child: FilledButton(
                              onPressed: () {
                                if (yesBtn != null) yesBtn();
                                Get.offAll(backWidget);
                              },
                              text: "Yes")),
                    ],
                  )
                ],
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))));
  }

  static InputDecoration simpleInputDecoration({
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
  }) =>
      InputDecoration(
        border: Ui.outlinedInputBorder(),
        contentPadding: contentPadding,
        fillColor: fillColor,
        errorBorder: Ui.outlinedInputBorder(),
        focusedBorder: Ui.outlinedInputBorder(),
        enabledBorder: Ui.outlinedInputBorder(),
      );

  ///decoration for text fields without a border
  static InputDecoration denseInputDecoration({
    EdgeInsetsGeometry? contentPadding,
    Color fillColor = AppColors.grey,
  }) =>
      InputDecoration(
        border: Ui.denseOutlinedInputBorder(),
        contentPadding: contentPadding,
        fillColor: fillColor,
        filled: true,
        errorBorder: Ui.denseOutlinedInputBorder(),
        focusedErrorBorder: Ui.denseOutlinedInputBorder(),
        focusedBorder: Ui.denseOutlinedInputBorder(),
        enabledBorder: Ui.denseOutlinedInputBorder(),
      );

  static InputBorder outlinedInputBorder({
    double circularRadius = 5,
  }) =>
      OutlineInputBorder(
        borderRadius: Ui.circularRadius(circularRadius),
      );

  static InputBorder denseOutlinedInputBorder({
    double circularRadius = 5,
  }) =>
      OutlineInputBorder(
          borderRadius: Ui.circularRadius(circularRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ));

  static TextStyle simpleInputStyle() => const TextStyle(
        color: AppColors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        fontFamily: Assets.appFontFamily,
      );

  static double heightPercent(double i) => Get.height.percent(i);

  static double widthPercent(double i) => Get.width.percent(i);
}
