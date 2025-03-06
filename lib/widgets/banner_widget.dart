import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_ecommerce_f/controllers/banners_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app-constant.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselController carouselController = CarouselController();
  final BannersController bannersController = Get.put(BannersController());

  @override
  Widget build(BuildContext context) {
    return RubberBand(
      child: Container(
        child: Obx(() {
          return CarouselSlider(
              items: bannersController.bannerUrls
                  .map((imageUrls) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.cover,
                            width: Get.width - 10,
                            placeholder: (context, url) => ColoredBox(
                                color: AppConstant.appMainColor,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                )),
                        errorWidget: (context,url,error)=>Icon(Icons.error),),
                      ))
                  .toList(),
              options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 1,
                  scrollDirection: Axis.horizontal));
        }),
      ),
    );
  }
}
