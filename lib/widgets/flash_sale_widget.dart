import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_f/models/product_model.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/product_detail_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_imagecards/flutter_imagecards.dart';
import 'package:get/get.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: true).get(),
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
            return SizedBox(
              height: Get.height / 4.5,
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
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
                            padding: EdgeInsets.all(5.0),
                            child: FillImageCards(
                              width: Get.width / 3,
                              heightImage: Get.height / 10,
                              borderRadius: 20.0,
                              imageProvider: CachedNetworkImageProvider(
                                productModel.productImg.isNotEmpty ? productModel.productImg : 'https://images-cdn.ubuy.co.in/678980cc7e4e461a695c48ae-scarfs-for-women-winter-scarf-for.jpg',
                              ),
                              title: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),
                              ),
                              description: SizedBox(height: 2.0,),
                              footer: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Rs ${productModel.salePrice}',style: TextStyle(fontSize: 10),),
                                  SizedBox(width: 2.0,),
                                  Text(' ${productModel.fullPrice}',style: TextStyle(fontSize: 10,decoration: TextDecoration.lineThrough,color:AppConstant.radColor,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            );
          }
          return Container();
        });
  }
}
