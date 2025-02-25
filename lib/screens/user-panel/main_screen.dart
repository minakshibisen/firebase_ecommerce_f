import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:firebase_ecommerce_f/widgets/category_widget.dart';
import 'package:firebase_ecommerce_f/widgets/flash_sale_widget.dart';
import 'package:firebase_ecommerce_f/widgets/heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/banner_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppConstant.appSecondaryColor),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 250,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child:
                          const Icon(Icons.tune_rounded, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Minkashi Bisen',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            _drawerItem(Icons.person, 'My Profile'),
            _drawerItem(Icons.book, 'My Order'),
            _drawerItem(Icons.workspace_premium, 'Offers'),
            _drawerItem(Icons.video_label, 'My Favorite'),
            _drawerItem(Icons.edit, 'Edit Profile'),
            _drawerItem(Icons.logout, 'LogOut'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: Get.height / 90.0),
            const BannerWidget(),
            SizedBox(height: Get.height / 90.0),
            HeadingWidget(
              headingTitle: 'Categories',
              headingSubTItle: 'According to your budget',
              onTap: () {},
              buttonText: 'See More >',
            ),
            SizedBox(height: Get.height / 90.0),
            const CategoryWidget(),
            SizedBox(height: Get.height / 90.0),
            HeadingWidget(
              headingTitle: 'Flash Sale',
              headingSubTItle: 'Grab the best deals',
              onTap: () {},
              buttonText: 'See More >',
            ),
            SizedBox(height: Get.height / 90.0),
            const FlashSaleWidget(),
            SizedBox(height: Get.height / 90.0),
            HeadingWidget(
              headingTitle: 'All Product',
              headingSubTItle: 'All Product',
              onTap: () {},
              buttonText: 'See More >',
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppConstant.appSecondaryColor),
      title: Text(title, style: const TextStyle(color: AppConstant.appSecondaryColor)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
