import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_f/screens/user-panel/main_screen.dart';
import 'package:firebase_ecommerce_f/services/generate_order_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/order_model.dart';

void placeOrder(
    {required BuildContext context,
    required String customerDeviceToken,
    required String customerName,
    required String customerAddress,
    required String customerPhone}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: 'Please wait');
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        //order id generate

        String orderId = generateOrderId();
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
            customerId: user.uid,
            status: false,
            customerPhone: customerPhone,
            customerName: customerName,
            customerAddress: customerAddress,
            customerDeviceId: customerDeviceToken);

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set({
            'uId': user.uid,
            'customerName': customerName,
            'customerPhone': customerPhone,
            'customerAddress': customerAddress,
            'customerDeviceToken': customerDeviceToken,
            'oderStatus': false,
            'createdAt': DateTime.now(),
          });

          //upload order
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(orderModel.toMap());

          //delete cart
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete();
        }
      }
      print('Order Confirm');
      Get.snackbar(
        'Order Confirmed',
        "Thank you for your order!",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 5),
      );
      EasyLoading.dismiss();
      Get.offAll(()=>MainScreen());
    } catch (e) {
      print('Error$e');
    }
  }
}
