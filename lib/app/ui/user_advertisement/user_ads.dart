import 'dart:convert';
import 'package:admin_alamuti/app/controller/detail_page_advertisement.dart';
import 'package:admin_alamuti/app/data/model/Advertisement.dart';
import 'package:admin_alamuti/app/data/provider/advertisement_provider.dart';
import 'package:admin_alamuti/app/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:admin_alamuti/app/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:admin_alamuti/app/ui/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserAdvertisement extends StatefulWidget {
  UserAdvertisement({Key? key}) : super(key: key);

  @override
  State<UserAdvertisement> createState() => _UserAdvertisementState();
}

class _UserAdvertisementState extends State<UserAdvertisement> {
  AdvertisementProvider advertisementProvider = AdvertisementProvider();

  final DetailPageController detailPageController =
      Get.put(DetailPageController());

  final double width = Get.width;
  final double height = Get.height;

  final _userAdsPagingController =
      PagingController<int, Advertisement>(firstPageKey: 1);

  @override
  void initState() {
    _userAdsPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سایر آگهی های این کاربر'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: Colors.greenAccent,
        onRefresh: () => Future.sync(
          () => _userAdsPagingController.refresh(),
        ),
        child: PagedListView.separated(
          pagingController: _userAdsPagingController,
          builderDelegate: PagedChildBuilderDelegate<Advertisement>(
            itemBuilder: (context, ads, index) => Container(
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
                      vertical: height / 100, horizontal: width / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (ads.listviewPhoto == null)
                              ? Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                    'assets/logo/no-image.png',
                                    fit: BoxFit.cover,
                                    height: height / 6,
                                    width: height / 6,
                                  ),
                                )
                              : Image.memory(
                                  base64Decode(
                                    ads.listviewPhoto!,
                                  ),
                                  fit: BoxFit.cover,
                                  height: height / 6,
                                  width: height / 6,
                                ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                ads.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(
                                height: height / 18,
                              ),
                              Text(
                                'تومان ${ads.price.toString()}',
                                style: TextStyle(
                                    fontFamily: persianNumber,
                                    fontWeight: FontWeight.w300),
                                textDirection: TextDirection.rtl,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    ads.datePosted,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontFamily: persianNumber,
                                        fontSize: 13),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    ads.village,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontFamily: persianNumber,
                                        fontSize: 13),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _userAdsPagingController.error,
              onTryAgain: () async {
                _userAdsPagingController.refresh();
              },
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(
              onTryAgain: () {
                return _userAdsPagingController.refresh();
              },
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            height: 0,
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var newPage;

      newPage = await advertisementProvider.getUserAdvertisement(
        number: pageKey,
        size: 3,
        userId: detailPageController.details[0].userId,
      );

      final previouslyFetchedItemsCount =
          _userAdsPagingController.itemList?.length ?? 0;

      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (isLastPage) {
        _userAdsPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _userAdsPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _userAdsPagingController.error = error;
    }
  }

  @override
  void dispose() {
    _userAdsPagingController.dispose();
    super.dispose();
  }
}
