import 'dart:convert';
import 'package:alamuti/app/controller/ConnectionController.dart';
import 'package:alamuti/app/controller/advertisementController.dart';
import 'package:alamuti/app/controller/selectedTapController.dart';
import 'package:alamuti/app/data/model/Advertisement.dart';
import 'package:alamuti/app/data/provider/advertisement_provider.dart';
import 'package:alamuti/app/ui/details/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAdvertisement extends StatefulWidget {
  final String? adstype;

  const UserAdvertisement({Key? key, this.adstype}) : super(key: key);
  @override
  State<UserAdvertisement> createState() => _UserAdvertisementState();
}

class _UserAdvertisementState extends State<UserAdvertisement> {
  int selectedTap = 4;
  bool isTyping = false;
  var ap = AdvertisementProvider();

  List<Advertisement> adsList = [];

  ConnectionController connectionController = Get.put(ConnectionController());

  ScreenController screenController = Get.put(ScreenController());

  ListAdvertisementController listAdvertisementController =
      Get.put(ListAdvertisementController());

  @override
  void initState() {
    super.initState();

    connectionController.checkConnectionStatus();
  }

  int tag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('آگهی های این کاربر'),
        centerTitle: true,
      ),
      body: (!connectionController.isConnected.value)
          ? Center(
              child: Text('لطفا اتصال به اینترنت همراه خود را بررسی کنید'),
            )
          : Obx(() => ListView.builder(
                itemCount: listAdvertisementController.adsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: GestureDetector(
                      onTap: () => Get.to(
                          () => AdsDetail(
                                adsId: listAdvertisementController
                                    .adsList[index].id,
                                byteImage1: listAdvertisementController
                                    .adsList[index].photo1,
                                byteImage2: listAdvertisementController
                                    .adsList[index].photo2,
                                price: listAdvertisementController
                                    .adsList[index].price
                                    .toString(),
                                sendedDate: listAdvertisementController
                                    .adsList[index].datePosted,
                                title: listAdvertisementController
                                    .adsList[index].title,
                                userId: listAdvertisementController
                                    .adsList[index].userId,
                                description: listAdvertisementController
                                    .adsList[index].description,
                              ),
                          transition: Transition.noTransition),
                      child: Obx(() => Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: (listAdvertisementController
                                                    .adsList[index].photo1 ==
                                                null)
                                            ? Opacity(
                                                opacity: 0.6,
                                                child: Image.asset(
                                                  'assets/logo/no-image.png',
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      6,
                                                ),
                                              )
                                            : Image.memory(
                                                base64Decode(
                                                  listAdvertisementController
                                                      .adsList[index].photo1,
                                                ),
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    6,
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              70),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            listAdvertisementController
                                                .adsList[index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                18,
                                          ),
                                          Text(
                                            '${listAdvertisementController.adsList[index].price.toString()}  تومان',
                                            style: TextStyle(
                                                fontFamily: 'IRANSansXFaNum',
                                                fontWeight: FontWeight.w300),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          Text(
                                            listAdvertisementController
                                                .adsList[index].datePosted,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'IRANSansXFaNum',
                                                fontSize: 13),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  );
                },
              )),
    );
  }
}
