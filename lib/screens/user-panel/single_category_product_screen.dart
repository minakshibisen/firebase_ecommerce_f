import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/product_detail_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_imagecards/flutter_imagecards.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';

class SingleCategoryProductScreen extends StatefulWidget {
  String catId;
  SingleCategoryProductScreen({super.key, required this. catId});

  @override
  State<SingleCategoryProductScreen> createState() => _SingleCategoryProductScreenState();
}

class _SingleCategoryProductScreenState extends State<SingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(title: Text('Products'),
        backgroundColor: AppConstant.appMainColor,),
      body: FutureBuilder(
          future: FirebaseFirestore.instance.collection('products').where('catId',isEqualTo: widget.catId).get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Category Found!'),
              );
            }
            if (snapshot.data != null) {
              return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1.19),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    String imageUrl;
                    if (productData['productImg'] is List && productData['productImg'].isNotEmpty) {
                      imageUrl = productData['productImg'][0]; // Get first image from list
                    } else {
                      imageUrl = productData['productImg'].toString(); // Convert to string
                    }
                    ProductModel productModel = ProductModel(
                        productId:productData['productId'] .toString(),
                        catId: productData['catId'].toString(),
                        productName:productData ['productName'].toString(),
                        catName:productData ['catName'].toString(),
                        salePrice: productData ['salePrice'].toString(),
                        fullPrice: productData ['fullPrice'].toString(),
                        productImg:imageUrl,
                        deliveryTime: productData['deliveryTime'].toString(),
                        isSale: productData['isSale'],
                        productDescription:productData ['productDescription'].toString(),
                        createdAt: productData['createdAt'],
                        updatedAt:productData ['updatedAt']);

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.to(() => ProductDetailScreen(productModel: productModel)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FillImageCards(
                              width: Get.width / 2.3,
                              heightImage: Get.height / 10,
                              borderRadius: 20.0,
                              imageProvider: CachedNetworkImageProvider(
                                productModel.productImg,
                              ),
                              title: Center(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    productModel.productName,
                                    style: TextStyle(fontSize: 12.0),
                                  )),
                            ),
                          ),
                        )
                      ],
                    );
                  } );

              /* SizedBox(
                height: Get.height / 5,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder:),
              );*/
            }
            return Container();
          }),
    );
  }
}
