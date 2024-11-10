import 'dart:async';
import 'dart:convert';

import 'package:admin_alamuti/app/data/model/login_request_model.dart';
import 'package:admin_alamuti/app/data/model/login_response_model.dart';
import 'package:admin_alamuti/app/data/model/register_request_model.dart';
import 'package:admin_alamuti/app/data/model/register_response_model.dart';
import 'package:admin_alamuti/app/data/storage/cachemanager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginProvider extends GetConnect with CacheManager {
  final String loginUrl = 'https://alamuti.ir/api/auth/login';

  final String registerUrl = 'https://alamuti.ir/api/auth/authenticate';
  final Dio dio = Dio();

  Future<LoginResponseModel?> fetchLogin(
      LoginRequestModel model, BuildContext context) async {
    var url = Uri.parse('https://alamuti.ir/api/auth/login');

    var response = await http.post(
      url,
      body: jsonEncode(model),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(body['token']);
      print(body['refreshToken']);

      return LoginResponseModel.fromJson(body);
    } else {
      var message = 'کد ورود اشتباه است ...';

      return null;
    }
  }

  Future<RegisterResponseModel?> fetchRegister(
      RegisterRequestModel model, BuildContext context) async {
    try {
      var url = Uri.parse('https://alamuti.ir/api/auth/authenticate');
      print(url);
      var response = await http.post(
        url,
        body: jsonEncode(model),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      ).timeout(Duration(seconds: 16));
      print('=================register line 57');
      var body = jsonDecode(response.body);
      print(body);
      if (response.statusCode == 200) {
        print('successful');
        await saveUserId(body['id']);

        // Pushe.setCustomId(getUserId());

        return RegisterResponseModel.fromJson(body);
      } else {
        var message = 'خطا در اتصال به اینترنت ...';
        print('not successful');

        return null;
      }
    } on TimeoutException catch (e) {
      var message = 'خطا در اتصال به اینترنت ...';
      print(e);
      print('==========');

      return null;
    } catch (e) {
      print(e);
      print('=========');
    }
    return null;
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
