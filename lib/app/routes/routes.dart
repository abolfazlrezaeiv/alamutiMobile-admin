import 'package:alamuti/app/ui/Login/register.dart';
import 'package:alamuti/app/ui/home/home_page.dart';
import 'package:alamuti/app/ui/splash_screen/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/get_navigation.dart' as trans;

var routes = [
  GetPage(
      name: '/',
      page: () => SplashScreen(),
      transition: trans.Transition.noTransition),
  GetPage(
      name: '/home',
      page: () => HomePage(),
      transition: trans.Transition.noTransition),
  GetPage(
    name: "/register",
    page: () => Registeration(),
    transition: trans.Transition.noTransition,
  ),
];
