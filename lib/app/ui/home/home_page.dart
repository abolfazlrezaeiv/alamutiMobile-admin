import 'dart:convert';
import 'package:admin_alamuti/app/bindings/detail_binding.dart';
import 'package:admin_alamuti/app/controller/authentication_manager.dart';
import 'package:admin_alamuti/app/controller/selectedTapController.dart';
import 'package:admin_alamuti/app/data/model/Advertisement.dart';
import 'package:admin_alamuti/app/data/provider/advertisement_provider.dart';
import 'package:admin_alamuti/app/ui/details/detail_page.dart';
import 'package:admin_alamuti/app/ui/widgets/buttom_navbar_items.dart';
import 'package:admin_alamuti/app/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:admin_alamuti/app/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:admin_alamuti/app/ui/widgets/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdvertisementProvider advertisementProvider = AdvertisementProvider();

  final double width = Get.width;
  final double height = Get.height;

  AuthenticationManager auth = Get.put(AuthenticationManager());
  ScreenController screenController = Get.put(ScreenController());

  final _pagingController = PagingController<int, Advertisement>(
      firstPageKey: 1, invisibleItemsThreshold: 2);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: screenController.selectedIndex.value,
          onTap: (value) async {
            screenController.selectedIndex.value = value;
            if (value == 0) {
              screenController.isReportPage.value = false;
            }
            if (value == 1) {
              screenController.isReportPage.value = true;
            }
            print(screenController.isReportPage);
            _pagingController.refresh();
          },
          items: bottomTapItems,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Obx(() => AppBar(
              title: screenController.isReportPage.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark_circle,
                          color: Colors.white,
                        ),
                        Text('آگهی های گزارش شده'),
                      ],
                    )
                  : Text('آگهی های تایید نشده'),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () => auth.logOut(), icon: Icon(Icons.logout))
              ],
            )),
      ),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: RefreshIndicator(
          color: Colors.greenAccent,
          onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
          child: PagedListView.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Advertisement>(
              itemBuilder: (context, ads, index) => GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await advertisementProvider.getDetails(
                      id: ads.id, context: context);
                  Get.to(
                      () => AdsDetail(
                            id: ads.id,
                          ),
                      binding: DetailPageBinding(),
                      transition: Transition.fadeIn);
                },
                child: Container(
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
                              padding:
                                  EdgeInsets.symmetric(vertical: height / 70),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ads.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
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
              ),
              firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                error: _pagingController.error,
                onTryAgain: () async {
                  _pagingController.refresh();
                },
              ),
              noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(
                onTryAgain: () {
                  return _pagingController.refresh();
                },
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(
              height: 0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var newPage;
      if (screenController.isReportPage.value == false) {
        newPage = await advertisementProvider.getAllUnpublished(
          number: pageKey,
          size: 10,
        );
      } else {
        newPage = await advertisementProvider.getReports(
          number: pageKey,
          size: 10,
        );
      }

      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;

      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
