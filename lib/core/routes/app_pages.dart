import 'package:get/get.dart';
import 'package:parthasarathy_abga/core/routes/app_routes.dart';
import 'package:parthasarathy_abga/home/ui/home_page.dart';

import '../../home/home_binding.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
        name: Routes.home, page: () => const HomePage(), binding: HomeBinding())
  ];
}
