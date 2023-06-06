// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parthasarathy_abga/home/home_controller.dart';
import 'package:parthasarathy_abga/home/ui/message_tile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/message_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  void permissionHandler() async {
    var smsPermission = Permission.sms;
    var requestPermission = smsPermission.request();

    if (await requestPermission.isGranted) {
      controller.readAllSms();
    } else {
      Fluttertoast.showToast(
        msg: 'Please enable sms permission in App settings and restart the app',
        toastLength: Toast.LENGTH_LONG
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    permissionHandler();
    return Scaffold(
      appBar: AppBar(title: const Text('Messages'), actions: <Widget>[
        IconButton(
            onPressed: () {
              controller.readAllSms();
            },
            icon: const Icon(Icons.refresh)),
        IconButton(
            onPressed: () {
              _pieChartBuilder(context);
            },
            icon: const Icon(Icons.pie_chart))
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: TextField(
                  decoration: const InputDecoration(hintText: 'search sender'),
                  onChanged: (value) {
                    controller.onSearchEntered(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<MessageView>>(
              stream: controller.listenMessages.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<MessageView>> snapshot) {
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

                var msgViews = snapshot.data!;
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: msgViews.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (msgViews[index] is MessageDetail) {
                                return MessageTile(
                                    messageDetail:
                                        msgViews[index] as MessageDetail);
                              }
                              if (msgViews[index] is MessageMonth) {
                                return Center(
                                    child: Text(
                                  (msgViews[index] as MessageMonth).month,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ));
                              }

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text('Total of the month',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'AED ${(msgViews[index] as MonthlyTotal).total}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              );
                            }),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        color: Colors.blue,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'AED ${controller.calcTotalAmount(msgViews)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pieChartBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Total Spending by Name'),
            content: SingleChildScrollView(
              child: PieChart(
                dataMap: controller.pieChartData,
                legendOptions:
                    const LegendOptions(legendPosition: LegendPosition.bottom),
              ),
            ),
          );
        });
  }
}
