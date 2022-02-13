import 'package:get/get.dart';
import 'package:score_square/ui/login/login_page.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    // GetPage(name: '/', page: () => MyHomePage()),
    GetPage(name: '/login', page: () => LoginPage()),
  ];
}
