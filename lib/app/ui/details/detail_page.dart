import 'dart:convert';
import 'package:admin_alamuti/app/controller/detail_page_advertisement.dart';
import 'package:admin_alamuti/app/data/provider/advertisement_provider.dart';
import 'package:admin_alamuti/app/ui/details/fullscreen_image.dart';
import 'package:admin_alamuti/app/ui/details/fullscreen_slider.dart';
import 'package:admin_alamuti/app/ui/home/home_page.dart';
import 'package:admin_alamuti/app/ui/user_advertisement/user_ads.dart';
import 'package:admin_alamuti/app/ui/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdsDetail extends StatefulWidget {
  final int id;

  AdsDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<AdsDetail> createState() => _AdsDetailState();
}

class _AdsDetailState extends State<AdsDetail> {
  final DetailPageController detailPageController = Get.find();

  final double width = Get.width;

  final double height = Get.height;

  final AdvertisementProvider advertisementProvider = AdvertisementProvider();

  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ((detailPageController.details[0].photo1 != null) &&
                        (detailPageController.details[0].photo2 != null))
                    ? getImageSlider()
                    : getImageOrEmpty(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width / 20,
                  ),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height / 55,
                          ),
                          child: Text(
                            detailPageController.details[0].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: width / 24),
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  print(detailPageController.details[0].userId);
                                  Get.to(() => UserAdvertisement());
                                },
                                child: Text(
                                  'سایر آگهی های این کاربر',
                                  style: TextStyle(color: Colors.red),
                                )),
                            Text(
                              detailPageController.details[0].village +
                                  ' ' +
                                  detailPageController.details[0].datePosted
                                      .trim(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: persianNumber,
                                  fontSize: width / 31),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 55,
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: width / 55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${detailPageController.details[0].price} تومان',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: persianNumber,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                getPriceTitle(),
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: width / 27),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        getAreaRealState(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          detailPageController.details[0].reportMessage != null
                              ? TextButton(
                                  onPressed: () {
                                    showReportDialog(
                                        context: context,
                                        report: detailPageController
                                            .details[0].reportMessage);
                                  },
                                  child: Row(
                                    children: [
                                      Text('خواندن گزارش    '),
                                      Icon(
                                        CupertinoIcons
                                            .exclamationmark_circle_fill,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          Text(
                            'توضیحات',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: width / 24),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 55,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          detailPageController.details[0].description,
                          maxLines: 7,
                          overflow: TextOverflow.visible,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: width / 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.0, vertical: height / 50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await advertisementProvider.rejectAdvertisement(
                          detailPageController.details[0].id);
                      Get.to(() => HomePage());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width / 6, vertical: Get.width / 90),
                      child: Text(
                        'رد کردن',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.red.withOpacity(0.5),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (detailPageController.details[0].reportMessage ==
                          null) {
                        await advertisementProvider.changeToPublish(
                            detailPageController.details[0].id);
                      }
                      if (detailPageController.details[0].reportMessage !=
                          null) {
                        await advertisementProvider.clearReport(
                            id: detailPageController.details[0].id,
                            context: context);
                      }

                      Get.to(() => HomePage());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width / 6.0,
                          vertical: Get.width / 90),
                      child: Text(
                        'تایید',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(10, 210, 71, 0.4),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getImageSlider() {
    return Stack(children: [
      ImageSlideshow(
        width: double.infinity,
        height: height / 3,
        initialPage: 0,
        indicatorColor: Colors.greenAccent,
        indicatorBackgroundColor: Colors.white,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => FullscreenImageSlider(
                  image1: detailPageController.details[0].photo1!,
                  image2: detailPageController.details[0].photo2!,
                ),
              );
            },
            child: ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  colors: [Colors.transparent, Colors.white],
                ).createShader(
                    Rect.fromLTRB(-200, -200, Get.width / 2, Get.width / 2));
              },
              blendMode: BlendMode.dstIn,
              child: Image.memory(
                base64Decode(detailPageController.details[0].photo1!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => FullscreenImageSlider(
                  image1: detailPageController.details[0].photo1!,
                  image2: detailPageController.details[0].photo2!,
                ),
              );
            },
            child: ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  colors: [Colors.transparent, Colors.white],
                ).createShader(Rect.fromLTRB(-200, -200, width / 2, width / 2));
              },
              blendMode: BlendMode.dstIn,
              child: Image.memory(
                base64Decode(detailPageController.details[0].photo2!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        autoPlayInterval: null,
        isLoop: true,
      ),
      Container(
        padding: EdgeInsets.only(top: width / 12, left: width / 45),
        width: width,
        height: height / 3,
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: width / 5,
            height: width / 9,
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.back,
                  size: width / 20,
                  color: Colors.black,
                ),
                Text(
                  'بازگشت',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: width / 23),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  showReportDialog({required context, required String report}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 3,
      content: Text(
        report,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: Get.width / 25,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back(closeOverlays: true);
            },
            child: Text(
              'تایید',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.w400,
                fontSize: Get.width / 27,
              ),
            ))
      ],
    );
    showDialog(
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
      context: context,
    );
  }

  Widget getImageOrEmpty() {
    if (detailPageController.details[0].photo1 != null) {
      return singleImage(detailPageController.details[0].photo1);
    }

    if (detailPageController.details[0].photo2 != null) {
      return singleImage(detailPageController.details[0].photo2);
    }

    return getAppbarWithBack();
  }

  Widget singleImage(String? image) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullscreenImage(image: image!),
        );
      },
      child: Stack(
        children: [
          Container(
            height: height / 2.5,
            width: width,
            child: ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  colors: [Colors.transparent, Colors.white],
                ).createShader(
                    Rect.fromLTRB(-200, -200, Get.width / 2, Get.width / 2));
              },
              blendMode: BlendMode.dstIn,
              child: Image.memory(
                base64Decode(image!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: width / 12, left: width / 45),
              width: width,
              height: height / 2.5,
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: width / 5,
                  height: width / 9,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.back,
                        size: width / 20,
                        color: Colors.black,
                      ),
                      Text(
                        'بازگشت',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: width / 23),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String getPriceTitle() {
    if (detailPageController.details[0].adsType ==
        AdsFormState.FOOD.toString().toLowerCase()) {
      return 'قیمت';
    }
    if (detailPageController.details[0].adsType ==
        AdsFormState.JOB.toString().toLowerCase()) {
      return 'حقوق ماهیانه';
    }

    return 'قیمت کل';
  }

  Widget getAreaRealState() {
    return (detailPageController.details[0].adsType ==
            AdsFormState.REALSTATE.toString().toLowerCase())
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: width / 55),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${detailPageController.details[0].area} متر',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          fontSize: width / 26,
                          fontFamily: persianNumber,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "متراژ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: width / 27,
                          fontFamily: persianNumber),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          )
        : Container();
  }

  Widget getAppbarWithBack() {
    return Container(
      color: Color.fromRGBO(8, 212, 76, 0.5),
      child: Padding(
        padding: EdgeInsets.only(top: 40.0, bottom: 20),
        child: Opacity(
          opacity: 0.5,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.back,
                  size: width / 20,
                  color: Colors.black,
                ),
                Text(
                  'بازگشت',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: width / 23),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum AdsFormState { REALSTATE, FOOD, JOB, Trap }
