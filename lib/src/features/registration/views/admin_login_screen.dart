import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/registration/views/widgets/login_header.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final controller = Get.find<RegistrationController>();

  @override
  void initState() {
    super.initState();
    if (controller.courses.isNotEmpty) {
      controller.textControllers[5].text = controller.courses[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Form(
              key: controller.pformkey,
              child: Column(children: [
                // LoginHeader(),
                Ui.boxHeight(24),
                // Obx(() {
                //   final c =
                //       controller.isCourse ? courseWidgets() : classWidgets();
                //   return Column(
                //     children: c,
                //   );
                // }),
                Obx(() {
                  return controller.courses.isEmpty
                      ? AppText.thin("No Courses Found for this lecturer")
                      : CustomTextField.dropdown(controller.courses,
                          controller.textControllers[5], "Choose Course Code");
                }),

                Ui.boxHeight(24),
                Obx(() {
                  return controller.courses.isEmpty
                      ? SizedBox()
                      : FilledButton.white(() async {
                          await controller.loginAdmin();
                        }, "Enter");
                }),

                Ui.boxHeight(24),
              ])),
        ),
      ),
    );
  }

  List<Widget> classWidgets() {
    return [
      CustomTextField.dropdown(
          UtilFunctions.faculties(), controller.textControllers[2], "Faculty",
          onChanged: (s) {
        controller.changeFAC(s);
      }),
      Obx(() {
        return CustomTextField.dropdown(
            UtilFunctions.departmentFor(controller.fac.value),
            controller.textControllers[3],
            "Department");
      }),
      CustomTextField.dropdown(
          UtilFunctions.levels(), controller.textControllers[4], "Level")
    ];
  }

  List<Widget> courseWidgets() {
    return [
      CustomTextField.dropdown(controller.courses,
          controller.textControllers[5], "Choose Course Code")
      // CustomTextField(
      //     "ABC301", "Enter Course Code", controller.textControllers[5],
      //     varl: FPL.text)
    ];
  }
}
