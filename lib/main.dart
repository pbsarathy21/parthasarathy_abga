import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    title: 'Transaction Monitor',
    initialRoute: AppPages.initial,
    getPages: AppPages.routes,
  ));
}
