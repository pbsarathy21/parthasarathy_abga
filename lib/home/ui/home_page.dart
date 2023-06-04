
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get/get.dart';
import 'package:parthasarathy_abga/home/home_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  void permissionHandler() async {
    var smsPermission = Permission.sms;
    var requestPermission = smsPermission.request();

    if (await requestPermission.isGranted) {
      print("Granted");
      controller.readSms();
    }

    if (await requestPermission.isDenied) {
      print("permission denied");
    }

    if (await requestPermission.isRestricted) {
      print("permission restricted");
    }

    if (await requestPermission.isPermanentlyDenied) {
      print("permission permanently disabled");
    }

    if (await smsPermission.shouldShowRequestRationale) {
      print("permission show rationale");
    }
  }

  @override
  Widget build(BuildContext context) {
    permissionHandler();
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<SmsMessage>>(
          stream: controller.listenMessages.stream,
          builder: (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'Something went wrong : ${snapshot.error.toString()}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Text(
                "Fetching...",
                style: TextStyle(fontSize: 36),
              ));
            }

            var smsMessages = snapshot.data!;
            return ListView.builder(
                itemCount: smsMessages.length,
                itemBuilder: (context, index) {
                  return Text(smsMessages[index].body!);
                });
          },
        ),
      ),
    );
  }
}
