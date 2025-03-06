import 'package:animate_do/animate_do.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_category_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_flash_sale_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/all_products_screen.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/location_screen.dart';
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
        backgroundColor: AppConstant.appMainColor,
        toolbarHeight: 80,
        centerTitle: true,

        // Leading Icon (Menu)
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.all(8.0), // Consistent margin
              width: 40, // Ensure same size
              height: 40,
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

        // Title
        title: Text(
          AppConstant.appMainName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppConstant.appSecondaryColor,
            fontSize: 25,
          ),
        ),

        // Action Icon (Shopping Bag)
        actions: [
          Builder(
            builder: (context) =>GestureDetector(
              onTap:(){
                Get.to(()=>AllCategoryScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0), // Align with leading
                child: Container(
                  margin: const EdgeInsets.all(8.0), // Same margin as leading
                  width: 40, // Same width & height
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 25,
                    color: AppConstant.appMainColor2,
                  ),
                ),
              )

          ),    )
        ],
      ),


      drawer:Drawer(
        backgroundColor: AppConstant.gray,
        child: Column(
          children: [
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: AppConstant.appMainColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        width: double.infinity,
                        height: 200,
                        'assets/images/img.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'minkashi@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(Icons.person, 'My Profile', () {}),
                  _drawerItem(Icons.person, 'Location', () {
                    Get.to(() => LocationPickerScreen());
                  }),
                  _drawerItem(Icons.shopping_bag_outlined, 'My Order', () {
                    Get.to(() => OrderScreen());
                  }),
                  _drawerItem(Icons.workspace_premium, 'Offers', () {}),
                  _drawerItem(Icons.favorite, 'My Favorite', () {}),
                  _drawerItem(Icons.edit, 'Edit Profile', () {}),
                  _drawerItem(Icons.logout, 'Log Out', () {}),
                ],
              ),
            ),
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
