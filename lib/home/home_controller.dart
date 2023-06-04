import 'dart:async';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final SmsQuery query = Get.find();

  final listenMessages = StreamController<List<SmsMessage>>();

  void readSms() async {
    var allSms = await query.getAllSms;
    listenMessages.sink.add(allSms);
  }
}