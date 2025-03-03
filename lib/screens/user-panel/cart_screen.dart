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
          title: Text('Cart Product '),
          backgroundColor: AppConstant.appMainColor,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('cart')
                .doc(user!.uid)
                .collection('cartOrders')
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
                  child: Text('No Category Found!'),
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
                                final cartData = snapshot.data!.docs[index];
                                print(cartData['productTotalPrice']);
                                String imageUrl;
                                if (cartData['productImg'] is List &&
                                    cartData['productImg'].isNotEmpty) {
                                  imageUrl = cartData['productImg'][0];
                                } else {
                                  imageUrl = cartData['productImg'].toString();
                                }
                                CartModel cartModel = CartModel(
                                    productId: cartData['productId'].toString(),
                                    catId: cartData['catId'].toString(),
                                    productName:
                                        cartData['productName'].toString(),
                                    catName: cartData['catName'].toString(),
                                    salePrice: cartData['salePrice'].toString(),
                                    fullPrice: cartData['fullPrice'].toString(),
                                    productImg: imageUrl,
                                    deliveryTime:
                                        cartData['deliveryTime'].toString(),
                                    isSale: cartData['isSale'],
                                    productDescription:
                                        cartData['productDescription']
                                            .toString(),
                                    createdAt: cartData['createdAt'],
                                    updatedAt: cartData['updatedAt'],
                                    productQuantity:
                                        cartData['productQuantity'],
                                    productTotalPrice: (double.tryParse(
                                            cartData['productTotalPrice']
                                                .toString()) ??
                                        0.0));

                                productPriceController.fetchProductPrice();
                                return SwipeActionCell(
                                  key: ObjectKey(cartModel.productId),
                                  backgroundColor: AppConstant.appSecondaryColor,
                                  trailingActions: [
                                    SwipeAction(
                                      onTap: (CompletionHandler handler) async {
                                        print('deleted');

                                        await FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user?.uid)
                                            .collection('cartOrders')
                                            .doc(cartModel.productId)
                                            .delete();
                                      },
                                      title: 'DELETE',
                                      forceAlignmentToBoundary: true,
                                      performsFirstActionWithFullSwipe: true,
                                      color: AppConstant.radColor,
                                    )
                                  ],
                                  child: cartItemCard(cartModel: cartModel),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height:100,
                            width: double.infinity,
                            child: Container(
                              color: AppConstant.appMainColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Total Price",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppConstant.appSecondaryColor,
                                          ),
                                        ),
                                        Text(
                                          'रु ${productPriceController.totalPrice.value.toString()}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppConstant.appSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:()=>Get.to(CheckoutScreen()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppConstant.appSecondaryColor,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "Checkout",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppConstant.appMainColor),
                                                ),
                                                SizedBox(width: 6,),
                                                Icon(Icons.arrow_forward,
                                                    color: AppConstant.appMainColor),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  Widget cartItemCard({required CartModel cartModel}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: AppConstant.appMainColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: cartModel.productImg,
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
                        cartModel.productName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        cartModel.productDescription,
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
                        (cartModel.salePrice),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        (cartModel.fullPrice),
                        style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Total Price: ',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (cartModel.productTotalPrice).toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ]),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => updateQuantity(
                            cartModel.productQuantity - 1, cartModel),
                      ),
                      Text(
                        cartModel.productQuantity.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => updateQuantity(
                            cartModel.productQuantity + 1, cartModel),
                      ),
                    ],
                  ),
                ),
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
