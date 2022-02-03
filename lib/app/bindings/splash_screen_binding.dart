import 'package:admin_alamuti/app/controller/authentication_manager.dart';
import 'package:get/get.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthenticationManager>(AuthenticationManager(), permanent: true);
  }
}
