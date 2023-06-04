import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parthasarathy_abga/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text("Hello World!!!")
            ],
          ),
        ),
      ),
    );
  }

}