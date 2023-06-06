import 'dart:async';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:parthasarathy_abga/home/models/message_view.dart';
import 'package:parthasarathy_abga/home/use_cases/extract_transaction_amount.dart';
import 'package:intl/intl.dart'; // for date format

class HomeController extends GetxController {
  final SmsQuery query = Get.find();
  final ExtractTransactionAmount extractTransactionAmount = Get.find();

  final listenMessages = StreamController<List<MessageView>>();
  final defaultDateTime = DateTime(1970);

  Map<String, double> pieChartData = {};

  List<SmsMessage> _allSms = List.empty();

  void readAllSms() async {
    await query.getAllSms.then((value) => _allSms = value);
    var messageViewList = convertSmsToMessageViews(_allSms);
    listenMessages.sink.add(messageViewList);
    calcPieChartData(messageViewList.whereType<MessageDetail>().toList());
  }

  void calcPieChartData(List<MessageDetail> msgDetailList) async {
    List<MessageDetail> transactedSmsList =
        msgDetailList.where((msgDetail) => msgDetail.amount > 0.0).toList();

    List<String> senderList =
        transactedSmsList.map((e) => e.sender).toSet().toList();

    for (var sender in senderList) {
      var senderMsgDetails =
          transactedSmsList.where((e) => e.sender == sender).toList();
      var total = calcTotalAmount(senderMsgDetails);

      pieChartData.addAll({sender: total});
    }
  }

  void onSearchEntered(String searchString) async {
    if (searchString.isEmpty) {
      var messageViewList = convertSmsToMessageViews(_allSms);
      listenMessages.sink.add(messageViewList);
      return;
    }

    SmsMessage? smsMessage = _allSms.firstWhereOrNull((sms) =>
        sms.sender?.toLowerCase().contains(searchString.toLowerCase()) ??
        false);

    if (smsMessage == null) {
      listenMessages.sink.add(List.empty());
      return;
    }

    var filteredSmsList =
        _allSms.where((sms) => sms.sender == smsMessage.sender).toList();
    var messageViewList = convertSmsToMessageViews(filteredSmsList);
    listenMessages.sink.add(messageViewList);
  }

  List<MessageView> convertSmsToMessageViews(List<SmsMessage> smsList) {
    smsList.sort((a, b) =>
        (a.date ?? defaultDateTime).compareTo(b.date ?? defaultDateTime));
    List<MessageView> messageViewList = [];
    var currentMonth = "";
    var monthlyTotal = 0.00;
    for (var sms in smsList.reversed.toList()) {
      String body = sms.body ?? "";
      String sender = sms.sender ?? "Unknown";
      String formattedDate =
          DateFormat('dd/MM/yyyy').format(sms.date ?? DateTime(1970));
      double amount = extractTransactionAmount(body) ?? 0.00;

      MessageDetail detail = MessageDetail(sender, formattedDate, amount, body);

      String month = DateFormat.MMMM().format(sms.date ?? DateTime(1970));

      if (currentMonth != month) {
        if (currentMonth.isNotEmpty) {
          messageViewList.add(MonthlyTotal(monthlyTotal));
          monthlyTotal = 0.00;
        }

        currentMonth = month;
        messageViewList.add(MessageMonth(month));
      }
      monthlyTotal += amount;
      messageViewList.add(detail);
    }
    return messageViewList;
  }

  double calcTotalAmount(List<MessageView> msgViews) {
    return msgViews
        .whereType<MessageDetail>()
        .map((e) => e.amount)
        .fold(0.00, (a, b) => a + b);
  }
}
