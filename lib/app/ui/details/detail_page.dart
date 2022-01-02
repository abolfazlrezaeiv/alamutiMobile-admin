import 'dart:convert';
import 'package:alamuti/app/data/provider/advertisement_provider.dart';
import 'package:alamuti/app/ui/details/fullscreen_image.dart';
import 'package:alamuti/app/ui/home/home_page.dart';
import 'package:alamuti/app/ui/user_advertisement/user_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AdsDetail extends StatelessWidget {
  final String? byteImage1;
  final String? byteImage2;
  final String title;
  final String price;
  final String sendedDate;
  final String userId;
  final int adsId;

  final String description;
  AdsDetail(
      {Key? key,
      required this.byteImage1,
      required this.byteImage2,
      required this.title,
      required this.price,
      required this.description,
      required this.userId,
      required this.sendedDate,
      required this.adsId})
      : super(key: key);

  AdvertisementProvider advertisementProvider = AdvertisementProvider();
  var ap = AdvertisementProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ((byteImage1 != null) && (byteImage2 != null))
                  ? getImageSlider()
                  : getImageOrEmpty(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width / 50,
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Get.height / 55,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await ap.getUserAdvertisement(userId);
                                Get.to(() => UserAdvertisement());
                              },
                              child: Text(
                                'سایر آگهی های این کاربر',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: Get.width / 26),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Text(
                              title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Get.width / 24),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        sendedDate,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'IRANSansXFaNum',
                            fontSize: Get.width / 31),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: Get.height / 55,
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.width / 55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$price   تومان',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26,
                                  fontFamily: 'IRANSansXFaNum',
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'قیمت',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 27),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width / 30, vertical: Get.height / 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'توضیحات',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width / 24),
                    ),
                    SizedBox(
                      height: Get.height / 55,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        description,
                        maxLines: 7,
                        overflow: TextOverflow.visible,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: MediaQuery.of(context).size.width / 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 8.0, vertical: Get.height / 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  height: Get.width / 9,
                  minWidth: Get.width / 2.2,
                  elevation: 0,
                  color: Colors.red.withOpacity(0.7),
                  onPressed: () {
                    advertisementProvider.rejectAdvertisement(this.adsId);
                    advertisementProvider.getAllUnpublished();

                    Get.to(() => HomePage());
                  },
                  child: Text(
                    'رد کردن',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width / 26,
                    ),
                  ),
                ),
                MaterialButton(
                  height: Get.width / 9,
                  minWidth: Get.width / 2.2,
                  elevation: 0,
                  color: Colors.greenAccent,
                  onPressed: () {
                    advertisementProvider.changeToPublish(this.adsId);
                    Get.to(() => HomePage());
                    advertisementProvider.getAllUnpublished();
                  },
                  child: Text(
                    'تایید',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width / 26,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getImageSlider() {
    return Stack(children: [
      ImageSlideshow(
        width: double.infinity,
        height: Get.height / 3,
        initialPage: 0,
        indicatorColor: Colors.greenAccent,
        indicatorBackgroundColor: Colors.white,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => FullscreenImage(image: byteImage1!),
              );
            },
            child: Image.memory(
              base64Decode(byteImage1!),
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => FullscreenImage(image: byteImage2!),
              );
            },
            child: Image.memory(
              base64Decode(byteImage2!),
              fit: BoxFit.cover,
            ),
          ),
        ],
        autoPlayInterval: null,
        isLoop: true,
      ),
      Container(
        padding: EdgeInsets.only(top: Get.width / 12, left: Get.width / 45),
        width: Get.width,
        height: Get.height / 3,
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () =>
              Get.to(() => HomePage(), transition: Transition.noTransition),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.back,
                size: 25,
                color: Colors.black,
              ),
              Text(
                'بازگشت',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
        ),
      ),
    ]);
  }

  Widget getImageOrEmpty() {
    return (byteImage1 != null)
        ? GestureDetector(
            onTap: () {
              Get.to(
                () => FullscreenImage(image: byteImage1!),
              );
            },
            child: Stack(children: [
              Container(
                height: Get.height / 2.5,
                width: Get.width,
                child: Image.memory(
                  base64Decode(byteImage1!),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: Get.width / 12, left: Get.width / 45),
                width: Get.width,
                height: Get.height / 2.5,
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Get.to(() => HomePage(),
                      transition: Transition.noTransition),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.back,
                        size: 25,
                        color: Colors.black,
                      ),
                      Text(
                        'بازگشت',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          )
        : getAppbarWithBack();
  }

  Widget getAppbarWithBack() {
    return Container(
      color: Colors.blue,
      child: Padding(
        padding: EdgeInsets.only(top: 40.0, bottom: 20),
        child: Opacity(
          opacity: 0.5,
          child: GestureDetector(
            onTap: () =>
                Get.to(() => HomePage(), transition: Transition.noTransition),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.back,
                  size: 25,
                  color: Colors.black,
                ),
                Text(
                  'بازگشت',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getStackedBackButton() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: Opacity(
        opacity: 0.7,
        child: GestureDetector(
          onTap: () =>
              Get.to(() => HomePage(), transition: Transition.noTransition),
          child: Container(
            width: Get.width / 4,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.back,
                  size: 25,
                  color: Colors.white,
                ),
                Text(
                  'بازگشت',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}