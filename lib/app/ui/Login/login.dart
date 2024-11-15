import 'package:admin_alamuti/app/controller/login_view_model.dart';
import 'package:admin_alamuti/app/controller/otp_request_controller.dart';
import 'package:admin_alamuti/app/data/storage/cachemanager.dart';
import 'package:admin_alamuti/app/ui/home/home_page.dart';
import 'package:admin_alamuti/app/ui/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatelessWidget {
  final OTPRequestController otpRequestController = Get.find();

  final LoginViewModel loginViewModelController = Get.find();

  final GlobalKey<FormState> formKey = GlobalKey();

  final storage = new GetStorage();

  final double width = Get.width;

  final double height = Get.height;

  final TextEditingController passwordCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0;
    checkPinCode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Obx(
            () => Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  alignment: Alignment.centerRight,
                  color: Color.fromRGBO(71, 68, 68, 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height / 14, right: 20, bottom: 15),
                        child: TextButton.icon(
                          icon: Icon(
                            CupertinoIcons.back,
                            color: Color.fromRGBO(112, 112, 112, 1),
                          ),
                          onPressed: () {
                            Get.offAllNamed('/register');
                          },
                          label: Text('بازگشت',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  color: Color.fromRGBO(112, 112, 112, 1))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height / 14,
                          right: 20,
                          bottom: 15,
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.asset(
                            'assets/logo/logo.png',
                            height: height / 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isKeyboardOpen
                    ? SizedBox(
                        height: height / 6,
                      )
                    : SizedBox(
                        height: 30,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Text(
                        "کد تایید را وارد کنید",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 18),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "کد تایید به شماره ${otpRequestController.phoneNumber.value} ارسال شد",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                              controller: passwordCtr,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length != 4) {
                                  return 'لطفا کد ارسال شده را وارد کنید';
                                }

                                return null;
                              },
                              decoration: inputDecoration(
                                  'کد ورود',
                                  !otpRequestController.isOTP.value
                                      ? CupertinoIcons.lock
                                      : CupertinoIcons.lock_open),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 180,
                    ),
                    Container(
                      width: width,
                      height: height / 11,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: otpRequestController.isOTP.value
                              ? Color.fromRGBO(141, 235, 172, 1)
                              : Colors.grey.withOpacity(0.5),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            var result = await loginViewModelController
                                .loginUser(passwordCtr.text, context);
                            if (result == true) {
                              Get.offAll(() => HomePage(),
                                  transition: Transition.noTransition);
                            } else {}

                            await storage.write(
                                CacheManagerKey.PASSWORD.toString(),
                                passwordCtr.text);
                          }
                        },
                        child: Text(
                          'تایید و ادامه',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  checkPinCode() {
    passwordCtr.addListener(() {
      var userInput = passwordCtr.text;
      if (userInput.isNotEmpty && userInput.isNum && userInput.length == 4) {
        otpRequestController.isOTP.value = true;
      } else {
        otpRequestController.isOTP.value = false;
      }
    });
  }
}
