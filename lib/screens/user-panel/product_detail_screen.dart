import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/models/cart_model.dart';
import 'package:firebase_ecommerce_f/models/product_model.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app-constant.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailScreen({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String selectedSize = "L";
  String selectedColor = "Black";

  final List<String> sizes = ["S", "M", "L", "XL", "XXL"];
  final List<String> colors = ["Black", "Green", "White", "Orange"];

  void updateQuantity(int change) {
    setState(() {
      if (quantity + change > 0) {
        quantity += change;
      }
    });
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    if (widget.productModel.productImg is List<String>) {
      images = widget.productModel.productImg as List<String>;
    } else if (widget.productModel.productImg.isNotEmpty) {
      images = widget.productModel.productImg.split(','); // Convert to list
    }

    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 13,
                child: Stack(
                  children:[
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
                      child: SizedBox(
                        height: Get.height * 0.6, // Adjusted height
                        child: CarouselSlider(
                          items: images.map((imageUrl) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl.trim(),
                                fit: BoxFit.cover,
                              width: double.infinity,
                                height: Get.height * 0.4,
                                placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1.5,
                            viewportFraction: 1,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        child: IconButton(
                          icon:
                          const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Get.to(()=>MainScreen());
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        child: IconButton(
                          icon:
                          const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                          onPressed: () {
                          Get.to(()=>CartScreen());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 25,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80),
                    // Prevent content from being covered
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productModel.productName,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.appTextColor),
                        ),
                        const Text(
                          "Vado Odelle Dress",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(Icons.star,
                                    color: Colors.amber, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("(320 Review)",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Available in stock",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstant.appTextColor),
                            ),
                            DropdownButton<String>(
                              value: selectedColor,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppConstant.appMainColor,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedColor = newValue!;
                                });
                              },
                              items: colors.map<DropdownMenuItem<String>>(
                                (String color) {
                                  return DropdownMenuItem<String>(
                                    value: color,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: color == "Black"
                                            ? AppConstant.appSecondaryColor
                                            : color == "Green"
                                                ? Colors.green
                                                : color == "White"
                                                    ? AppConstant.appMainColor
                                                    : Colors.orange,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                AppConstant.appSecondaryColor),
                                      ),
                                      width: 30,
                                      height: 30,
                                      child: color == selectedColor
                                          ? const Icon(Icons.check,
                                              color: AppConstant.appMainColor,
                                              size: 18)
                                          : null,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text("Size",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.appTextColor)),
                        Row(
                          children: sizes.map((size) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = size;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: selectedSize == size
                                      ? AppConstant.appSecondaryColor
                                      : AppConstant.appMainColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedSize == size
                                        ? AppConstant.appMainColor
                                        : AppConstant.appSecondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstant.appTextColor),
                        ),
                        SizedBox(height: Get.height / 50),
                        Text(
                          widget.productModel.productDescription,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        // Additional product details...
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 5),
              color: AppConstant.appMainColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appSecondaryColor,
                        ),
                      ),
                      Text(
                        "\$${(double.tryParse(widget.productModel.fullPrice) ?? 0 * quantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.appSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: () => updateQuantity(-1),
                          ),
                          Text("$quantity",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => updateQuantity(1),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.appSecondaryColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                        ),
                        onPressed: () async {
                          checkProductExistence(uId: user!.uid);
                        },
                        child: const Text(
                          'Add To Cart',
                          style: TextStyle(color: AppConstant.appMainColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();
//already cart me product hai to uski quantity add ho jayegi
    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice =
          double.parse(widget.productModel.fullPrice) * updatedQuantity;
      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      print('Product exists');
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });
      CartModel cartModel = CartModel(
          productId: widget.productModel.productId,
          catId: widget.productModel.catId,
          productName: widget.productModel.productName,
          catName: widget.productModel.catName,
          salePrice: widget.productModel.salePrice,
          fullPrice: widget.productModel.fullPrice,
          productImg: widget.productModel.productImg,
          deliveryTime: widget.productModel.deliveryTime,
          isSale: widget.productModel.isSale,
          productDescription: widget.productModel.productDescription,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productQuantity: 1,
          productTotalPrice: double.parse(widget.productModel.fullPrice));

      await documentReference.set(cartModel.toMap());
      print('Product Done');
    }
  }
}
