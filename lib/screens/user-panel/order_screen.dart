import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/controllers/product_price_controller.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_model.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstant.appSecondaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.arrow_back_sharp,
                size: 25,
                color: AppConstant.appMainColor2,
              ),
            ),
          ),
          toolbarHeight: 80,
          backgroundColor: AppConstant.appMainColor,
          title: Text(
            'Order Screen',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: AppConstant.appSecondaryColor, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .doc(user!.uid)
                .collection('confirmOrders')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  child: Text('No Order Found!'),
                );
              }
              if (snapshot.data != null) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Container(
                      color: AppConstant.appSecondaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = snapshot.data!.docs[index];
                                OrderModel orderModel = OrderModel(
                                  productId: data['productId'].toString(),
                                  catId: data['catId'].toString(),
                                  productName: data['productName'].toString(),
                                  catName: data['catName'].toString(),
                                  salePrice: data['salePrice'].toString(),
                                  fullPrice: data['fullPrice'].toString(),
                                  productImg: data['productImg'],
                                  deliveryTime: data['deliveryTime'].toString(),
                                  isSale: data['isSale'],
                                  productDescription:
                                      data['productDescription'].toString(),
                                  createdAt: DateTime.now(),
                                  updatedAt: data['updatedAt'],
                                  productQuantity: data['productQuantity'],
                                  productTotalPrice: (double.tryParse(
                                          data['productTotalPrice']
                                              .toString()) ??
                                      0.0),
                                  customerId: data['customerId'],
                                  status: data['status'],
                                  customerPhone: data['customerPhone'],
                                  customerName: data['customerName'],
                                  customerAddress: data['customerAddress'],
                                  customerDeviceId: data['customerDeviceId'],
                                );
                                productPriceController.fetchProductPrice();
                                return cartItemCard(orderModel: orderModel);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            }));
  }

  Widget cartItemCard({required OrderModel orderModel}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppConstant.gray,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                ColorFiltered(
                  colorFilter: ColorFilter.mode(AppConstant.gray, BlendMode.multiply),
                  child: CachedNetworkImage(
                    imageUrl: orderModel.productImg,
                    height: 80,
                    width: 100,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderModel.productName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.appMainColor2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        orderModel.productDescription,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppConstant.appTextColor,
                            fontWeight: FontWeight.normal),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (orderModel.salePrice),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal ,color: AppConstant.appMainColor2 ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (orderModel.fullPrice),
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
