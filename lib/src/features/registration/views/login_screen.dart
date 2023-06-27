import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/registration/views/forgot_password.dart';
import 'package:unn_attendance/src/features/registration/views/widgets/login_header.dart';
import 'package:unn_attendance/src/global/services/http_service.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class LoginScreen extends StatefulWidget {
  // final int userType;
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.find<RegistrationController>();

  @override
  void initState() {
    super.initState();
    controller.textControllers[0].text = controller.schools[0];
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Login",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Form(
              key: controller.formkey,
              child: Column(children: [
                Obx(() {
                  return controller.schools.isEmpty
                      ? CircularProgress(24)
                      : CustomTextField.dropdown(controller.schools,
                          controller.textControllers[0], "School");
                }),
                // controller.isLecturer(widget.userType)
                //     ? CustomTextField("Enter your Staff ID", "Staff ID",
                //         controller.textControllers[1], varl: FPL.text)
                //     : CustomTextField("2056/567890", "Registration Number",
                //         controller.textControllers[1],
                //         varl: FPL.text),
                CustomTextField("Email/Reg No/Staff ID", "ID",
                    controller.textControllers[1],
                    varl: FPL.text),
                CustomTextField.password(
                  "Password",
                  controller.textControllers[2],
                ),
                Ui.align(
                    align: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Get.to(ForgotPasswordScreen());
                        },
                        child: AppText.button("Forgot Password"))),
                Ui.boxHeight(24),

                FilledButton.white(() async {
                  await controller.onAppAuth(true);
                }, "Login"),
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
