import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:parthasarathy_abga/home/home_controller.dart';
import 'package:parthasarathy_abga/home/use_cases/extract_transaction_amount.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SmsQuery());
    Get.lazyPut(() => ExtractTransactionAmount());
    Get.lazyPut(() => HomeController());
  }
}