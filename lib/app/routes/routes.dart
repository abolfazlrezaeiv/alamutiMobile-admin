import 'package:admin_alamuti/app/bindings/login_binding.dart';
import 'package:admin_alamuti/app/bindings/register_binding.dart';
import 'package:admin_alamuti/app/bindings/splash_screen_binding.dart';
import 'package:admin_alamuti/app/ui/Login/login.dart';
import 'package:admin_alamuti/app/ui/Login/register.dart';
import 'package:admin_alamuti/app/ui/home/home_page.dart';
import 'package:admin_alamuti/app/ui/splash_screen/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/get_navigation.dart' as trans;

var routes = [
  GetPage(
      name: '/',
      page: () => SplashScreen(),
      binding: SplashScreenBinding(),
      transition: trans.Transition.noTransition),
  GetPage(
      name: '/home',
      page: () => HomePage(),
      transition: trans.Transition.noTransition),
  GetPage(
    name: "/register",
    page: () => Registeration(),
    binding: RegisterPageBinding(),
    transition: trans.Transition.noTransition,
  ),
  GetPage(
    name: "/login",
    page: () => Login(),
    binding: LoginPageBinding(),
    transition: trans.Transition.noTransition,
  ),
];
