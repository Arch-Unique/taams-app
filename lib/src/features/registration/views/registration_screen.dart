import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/registration/views/widgets/login_header.dart';
import 'package:unn_attendance/src/global/services/http_service.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class RegisterationScreen extends StatefulWidget {
  // final int userType;
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final controller = Get.find<RegistrationController>();
  String oldPass = "";
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.formkey = formkey;
    controller.textControllers[0].text = controller.schools[0];
    controller.textControllers[2].addListener(() {
      if (mounted) {
        setState(() {
          oldPass = controller.textControllers[2].value.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Register",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Form(
              key: controller.formkey,
              child: Column(children: [
                Obx(() {
                  return controller.schools.isEmpty
                      ? CircularProgress(24)
                      : CustomTextField.dropdown(controller.schools,
                          controller.textControllers[0], "School",
                          initOption: controller.textControllers[0].value.text);
                }),
                CustomTextField(
                    "Reg No/Staff ID", "ID", controller.textControllers[1],
                    varl: FPL.text),
                CustomTextField(
                    "John", "First Name", controller.textControllers[8],
                    varl: FPL.text),
                CustomTextField("Doe", "Surname", controller.textControllers[9],
                    varl: FPL.text),
                CustomTextField("johndoe@gmail.com", "Email",
                    controller.textControllers[11],
                    varl: FPL.email),
                CustomTextField.dropdown(["Lecturer", "Student", "Guardian"],
                    controller.textControllers[10], "Role",
                    initOption: controller.textControllers[10].value.text),
                CustomTextField.password(
                  "Password",
                  controller.textControllers[2],
                ),
                CustomTextField.password(
                    "Confirm Password", controller.textControllers[12],
                    oldPass: oldPass),
                Ui.boxHeight(24),

                FilledButton.white(() async {
                  await controller.onAppAuth(false);
                }, "Register"),
                Ui.boxHeight(24),
                // if (widget.userType != 2)
                //   AppText(
                //     "To get a code, please go to the ICT center, get an Attendance scratch card and input the code from there",
                //     color: AppColors.white40,
                //   )
              ])),
        ),
      ),
    );
  }
}
