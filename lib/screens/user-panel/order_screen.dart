import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/controllers/product_price_controller.dart';
import 'package:firebase_ecommerce_f/models/cart_model.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/checkout_screen.dart';
import 'package:firebase_ecommerce_f/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../models/order_model.dart';
import '../../utils/common_util.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppConstant.appSecondaryColor,
        appBar: AppBar(
          title: Text('Order Screen'),
          backgroundColor: AppConstant.appMainColor,
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
                  child: Text('Err or'),
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
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Container(
                      color: Colors.black,
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
                                print(data['productTotalPrice']);
                                String imageUrl;
                                if (data['productImg'] is List &&
                                    data['productImg'].isNotEmpty) {
                                  imageUrl = data['productImg'][0];
                                } else {
                                  imageUrl = data['productImg'].toString();
                                }
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
                                    productDescription: data['productDescription'].toString(),
                                    createdAt: DateTime.now(),
                                    updatedAt: data['updatedAt'],
                                    productQuantity: data['productQuantity'],
                                    productTotalPrice:
                                    (double.tryParse(data['productTotalPrice'].toString()) ?? 0.0),
                                    customerId: data['customerId'],
                                    status: data['status'],
                                    customerPhone: data['customerPhone'],
                                    customerName: data['customerName'],
                                    customerAddress:data['customerAddress'],
                                    customerDeviceId: data['customerDeviceId'],);

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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: orderModel.productImg,
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                const SizedBox(width: 15),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderModel.productName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        orderModel.productDescription,
                        style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
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
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (orderModel.fullPrice),
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                ]),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateQuantity(int count, CartModel cartModel) async {
    if (count <= 0) return;

    cartModel.productQuantity = count;
    cartModel.productTotalPrice = count * (stringToNumber(cartModel.salePrice));
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid)
        .collection('cartOrders')
        .doc(cartModel.productId)
        .update({
      'productQuantity': cartModel.productQuantity,
      'productTotalPrice': cartModel.productTotalPrice
    });
  }
}
