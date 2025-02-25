import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BannersController extends GetxController{
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fatchBannerUrls();

  }

 Future<void>  fatchBannerUrls() async{
    try{
      QuerySnapshot bannerSnapshot =await FirebaseFirestore.instance.collection('banners').get();
      if(bannerSnapshot.docs.isNotEmpty){
        bannerUrls.value=bannerSnapshot.docs.map((doc)=> doc['imageUrls']as String).toList();
      }
    }catch(e){
      if (kDebugMode) {
        print('error: $e');
      }
    }
 }


}