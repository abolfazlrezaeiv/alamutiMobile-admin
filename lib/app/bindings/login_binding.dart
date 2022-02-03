import 'package:admin_alamuti/app/controller/login_view_model.dart';
import 'package:admin_alamuti/app/controller/otp_request_controller.dart';
import 'package:get/get.dart';

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<OTPRequestController>(OTPRequestController());
    Get.put<LoginViewModel>(LoginViewModel());
  }
}
