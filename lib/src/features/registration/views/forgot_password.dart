import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unn_attendance/src/features/registration/controllers/registration_controller.dart';
import 'package:unn_attendance/src/features/registration/views/widgets/login_header.dart';
import 'package:unn_attendance/src/global/services/http_service.dart';
import 'package:unn_attendance/src/global/ui/ui_barrel.dart';
import 'package:unn_attendance/src/global/ui/widgets/fields/custom_textfield.dart';
import 'package:unn_attendance/src/global/ui/widgets/others/containers.dart';

import '../../../src_barrel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  // final int userType;
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final controller = Get.find<RegistrationController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Forgot Password",
      child: SingleChildScrollView(
        child: Ui.padding(
          child: Column(children: [
            CustomTextField(
                "johndoe@gmail.com", "Email", controller.textControllers[13],
                varl: FPL.email),
            Ui.boxHeight(24),

            FilledButton.white(() async {
              await controller.onForgotPassword();
            }, "Login"),
            Ui.boxHeight(24),
            // if (widget.userType != 2)
            //   AppText(
            //     "To get a code, please go to the ICT center, get an Attendance scratch card and input the code from there",
            //     color: AppColors.white40,
            //   )
          ]),
        ),
      ),
    );
  }
}
