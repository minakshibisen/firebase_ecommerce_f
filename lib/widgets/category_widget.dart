import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_f/models/category_model.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_imagecards/flutter_imagecards.dart';
import 'package:get/get.dart';

import '../screens/user-panel/single_category_product_screen.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
              child: Text('No Category Found!'),
            );
          }
          if (snapshot.data != null) {
            return RubberBand(
              child: SizedBox(
                height: Get.height / 5,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      CategoryModel categoryModel = CategoryModel(
                        catId: snapshot.data?.docs[index]['catId'],
                        catName: snapshot.data?.docs[index]['catName'],
                        category: snapshot.data?.docs[index]['category'],
                        createdAt: snapshot.data?.docs[index]['createdAt'],
                        updatedAt: snapshot.data?.docs[index]['updatedAt'],
                      );
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: ()=>Get.to(SingleCategoryProductScreen(catId:categoryModel.catId)),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: FillImageCards(
                                color: AppConstant.gray,
                                width: Get.width / 4.0,
                                heightImage: Get.height / 12,
                                borderRadius: 20.0,
                                imageProvider: CachedNetworkImageProvider(
                                  categoryModel.category,
                                ),
                                title: Center(
                                    child: Text(
                                  categoryModel.catName,
                                  style: TextStyle(fontSize: 12.0),
                                )),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            );
          }
          return Container();
        });
  }
}
