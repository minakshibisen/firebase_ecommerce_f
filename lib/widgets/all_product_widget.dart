import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_f/models/product_model.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_imagecards/flutter_imagecards.dart';
import 'package:get/get.dart';

import '../screens/user-panel/product_detail_screen.dart';

class AllProductWidget extends StatelessWidget {
  const AllProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: false).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              child: Text('No Products Found!'),
            );
          }
          if (snapshot.data != null) {
            return RubberBand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 3,
                        childAspectRatio: .7),
                    itemBuilder: (context, index) {
                      final productData = snapshot.data!.docs[index];
                      String imageUrl;
                      if (productData['productImg'] is List && productData['productImg'].isNotEmpty) {
                        imageUrl = productData['productImg'][0];
                      } else {
                        imageUrl = productData['productImg'].toString();
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
                            onTap: () => Get.to(() => ProductDetailScreen(productModel:productModel)),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: FillImageCards(
                                color: AppConstant.gray,
                                width: Get.width / 2.3,
                                heightImage: Get.height / 5,
                                borderRadius: 20.0,
                                imageProvider: CachedNetworkImageProvider(
                                  productModel.productImg.isNotEmpty ? productModel.productImg : 'https://images-cdn.ubuy.co.in/678980cc7e4e461a695c48ae-scarfs-for-women-winter-scarf-for.jpg',
                                ),
                                title: Text(
                                  productModel.productName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.normal,),
                                ),
                                footer: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Rs.${productModel.fullPrice}',style: TextStyle(fontSize: 14,color:AppConstant.appMainColor2,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } ),
              ),
            );
          }
          return Container();
        });
  }
}
