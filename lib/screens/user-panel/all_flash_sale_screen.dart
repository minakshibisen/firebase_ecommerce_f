import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imagecards/flutter_imagecards.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../utils/app-constant.dart';

class AllFlashSaleScreen extends StatefulWidget {
  const AllFlashSaleScreen({super.key});

  @override
  State<AllFlashSaleScreen> createState() => _AllFlashSaleScreenState();
}

class _AllFlashSaleScreenState extends State<AllFlashSaleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(
        title: const Text('All Sale Products'),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(child: CupertinoActivityIndicator()),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found!'));
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];

              String imageUrl = "";
              if (productData['productImg'] is List &&
                  productData['productImg'].isNotEmpty) {
                imageUrl = productData['productImg'][0];
              } else {
                imageUrl = productData['productImg'].toString();
              }

              ProductModel productModel = ProductModel(
                productId: productData['productId'].toString(),
                catId: productData['catId'].toString(),
                productName: productData['productName'].toString(),
                catName: productData['catName'].toString(),
                salePrice: productData['salePrice'].toString(),
                fullPrice: productData['fullPrice'].toString(),
                productImg: imageUrl,
                deliveryTime: productData['deliveryTime'].toString(),
                isSale: productData['isSale'],
                productDescription: productData['productDescription'].toString(),
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
              );

              return GestureDetector(
                onTap: () => Get.to(() => ProductDetailScreen(productModel: productModel)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FillImageCards(
                    width: Get.width / 2.3,
                    heightImage: Get.height / 5, // Increased image height
                    borderRadius: 15.0,
                    imageProvider: CachedNetworkImageProvider(imageUrl),
                    title: Text(
                      productModel.productName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    description: const SizedBox(height: 4.0),
                    footer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs ${productModel.salePrice}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' ${productModel.fullPrice}',
                          style: const TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: AppConstant.radColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
