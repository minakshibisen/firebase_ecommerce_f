import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
          title: Text(AppConstant.appMainName,textAlign: TextAlign.center),
        centerTitle: true,
      ),
    );
  }
}
