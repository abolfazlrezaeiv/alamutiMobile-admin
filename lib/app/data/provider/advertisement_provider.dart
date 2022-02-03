import 'dart:async';
import 'dart:convert';

import 'package:admin_alamuti/app/controller/detail_page_advertisement.dart';
import 'package:admin_alamuti/app/data/model/Advertisement.dart';
import 'package:admin_alamuti/app/data/model/list_page.dart';
import 'package:admin_alamuti/app/data/provider/token_provider.dart';
import 'package:admin_alamuti/app/data/provider/base_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';

class AdvertisementProvider {
  var tokenProvider = Get.put(TokenProvider());
  List<Advertisement> advertisementList = [];

  Future<void> rejectAdvertisement(int id) async {
    await tokenProvider.api.delete(baseUrl + 'Advertisement/unpublished/$id');
  }

  Future<void> changeToPublish(int id) async {
    await tokenProvider.api
        .put(baseUrl + 'Advertisement/changeToPublished/$id');
  }

  Future<void> getDetails(
      {required BuildContext context, required int id}) async {
    final DetailPageController detailPageController =
        Get.put(DetailPageController());

    showLoaderDialog(context);

    var response = await tokenProvider.api
        .get(baseUrl + 'Advertisement/$id')
        .whenComplete(() => Get.back());

    if (response.statusCode == 200) {
      detailPageController.details.value = [
        Advertisement.fromJson(response.data)
      ];
    } else {}
  }

  Future<ListPage<Advertisement>> getUserAdvertisement({
    int number = 1,
    int size = 10,
    required String userId,
  }) async {
    advertisementList = [];
    var response = await tokenProvider.api
        .get(baseUrl +
            'Advertisement/adminpaneluseradvertisement?userId=$userId&PageNumber=$number&PageSize=$size')
        .timeout(Duration(seconds: 5));

    var xPagination = jsonDecode(response.headers['X-Pagination']![0]);
    print(xPagination);

    response.data.forEach(
        (element) => advertisementList.add(Advertisement.fromJson(element)));

    return ListPage(
        itemList: advertisementList,
        grandTotalCount: xPagination['TotalCount']);
  }

  Future<ListPage<Advertisement>> getAllUnpublished({
    int number = 1,
    int size = 10,
    String? adstype,
  }) async {
    advertisementList = [];

    Response response;

    try {
      response = await tokenProvider.api
          .get(baseUrl +
              'Advertisement/getUnpublished?pageNumber=$number&pageSize=$size')
          .timeout(Duration(seconds: 7));

      var xPagination = jsonDecode(response.headers['X-Pagination']![0]);
      print(xPagination);

      if (response.statusCode == 200) {
        response.data.forEach(
          (element) {
            advertisementList.add(Advertisement.fromJson(element));
          },
        );

        return ListPage(
            itemList: advertisementList,
            grandTotalCount: xPagination['TotalCount']);
      } else {
        return ListPage(
            itemList: advertisementList,
            grandTotalCount: xPagination['TotalCount']);
      }
    } on TimeoutException catch (_) {
      throw TimeoutException('');
    }
  }

  Future<ListPage<Advertisement>> getReports({
    int number = 1,
    int size = 10,
    String? adstype,
  }) async {
    advertisementList = [];

    Response response;

    try {
      response = await tokenProvider.api
          .get(baseUrl +
              'Advertisement/report?pageNumber=$number&pageSize=$size')
          .timeout(Duration(seconds: 6));

      var xPagination = jsonDecode(response.headers['X-Pagination']![0]);
      print(xPagination);

      if (response.statusCode == 200) {
        response.data.forEach(
          (element) {
            advertisementList.add(Advertisement.fromJson(element));
          },
        );

        return ListPage(
            itemList: advertisementList,
            grandTotalCount: xPagination['TotalCount']);
      } else {
        return ListPage(
            itemList: advertisementList,
            grandTotalCount: xPagination['TotalCount']);
      }
    } on TimeoutException catch (_) {
      throw TimeoutException('');
    }
  }

  Future<void> clearReport({
    required BuildContext context,
    required int id,
  }) async {
    var response = await tokenProvider.api.put(
      baseUrl + 'Advertisement/report/$id',
    );
    print('object');
    if (response.statusCode == 200) {
      var message = 'گزارش پاک شد و آگهی به منتشر شد.';
      showStatusDialog(context: context, message: message);
    } else {
      var message = 'ارتباط ناموفق بود لطفا دوباره امتحان کنید';
      showStatusDialog(context: context, message: message);
    }
  }

  showLoaderDialog(context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
    showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
      context: context,
    );
  }

  showStatusDialog({required context, required String message}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      elevation: 3,
      content: Text(
        message,
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
}
