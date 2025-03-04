import 'package:animate_do/animate_do.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_category_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_flash_sale_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_products_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/order_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:firebase_ecommerce_f/widgets/all_product_widget.dart';
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
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.menu_open,
                  size: 25,
                  color: AppConstant.appMainColor2,
                ),
              ),
            ),
          ),
        ),
        toolbarHeight: 80,

        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppConstant.appSecondaryColor, fontSize: 25),
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        backgroundColor: AppConstant.gray,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 250,
              child: DrawerHeader(
                decoration:
                    const BoxDecoration(color: AppConstant.appSecondaryColor),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: AppConstant.appMainColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.tune_rounded,
                          color: AppConstant.appSecondaryColor),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Minkashi Bisen',
                      style: TextStyle(
                          fontSize: 20, color: AppConstant.appMainColor),
                    ),
                  ],
                ),
              ),
            ),
            _drawerItem(Icons.person, 'My Profile', () {}),
            _drawerItem(Icons.book, 'My Order', () {
              Get.to(() => OrderScreen());
            }),
            _drawerItem(Icons.workspace_premium, 'Offers', () {}),
            _drawerItem(Icons.video_label, 'My Favorite', () {}),
            _drawerItem(Icons.edit, 'Edit Profile', () {}),
            _drawerItem(Icons.logout, 'LogOut', () {}),
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
              headingSubtitle: 'According to your budget',
              // ✅ Fixed missing subtitle
              onTap: () => Get.to(() => AllCategoryScreen()),
              buttonText: 'See More >',
            ),
            FadeInLeft(child: const CategoryWidget()),
            HeadingWidget(
              headingTitle: 'Flash Sale',
              headingSubtitle: 'Grab the best deals',
              onTap: () => Get.to(() => AllFlashSaleScreen()),
              // ✅ Fixed navigation
              buttonText: 'See More >',
            ),
            FadeInLeft(child: const FlashSaleWidget()),
            HeadingWidget(
              headingTitle: 'All Products',
              headingSubtitle: 'According to your budget',
              onTap: () => Get.to(() => AllProductsScreen()),
              // ✅ Fixed navigation
              buttonText: 'See More >',
            ),
            FadeInDownBig(child: AllProductWidget())
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppConstant.appMainColor),
      title:
          Text(title, style: const TextStyle(color: AppConstant.appMainColor2)),
      onTap: onTap,
    );
  }
}
