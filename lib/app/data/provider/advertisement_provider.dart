import 'package:alamuti/app/controller/adsFormController.dart';
import 'package:alamuti/app/controller/advertisementController.dart';
import 'package:alamuti/app/controller/myAdvertisementController.dart';
import 'package:alamuti/app/data/model/Advertisement.dart';
import 'package:alamuti/app/data/provider/token_provider.dart';
import 'package:alamuti/app/data/provider/base_url.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';

class AdvertisementProvider {
  TokenProvider tokenProvider = Get.put(TokenProvider());
  AdsFormController adsFormController = Get.put(AdsFormController());
  ListAdvertisementController listAdvertisementController =
      Get.put(ListAdvertisementController());
  MyAdvertisementController myAdvertisementController =
      Get.put(MyAdvertisementController());

  Future<void> rejectAdvertisement(int id) async {
    for (var i = 0; i < listAdvertisementController.adsList.value.length; i++) {
      if (listAdvertisementController.adsList[i].id == id) {
        listAdvertisementController.adsList.value.removeAt(i);
        break;
      }
    }
    await tokenProvider.api.delete(baseUrl + 'Advertisement/unpublished/$id');
  }

  Future<void> changeToPublish(int id) async {
    for (var i = 0; i < listAdvertisementController.adsList.value.length; i++) {
      if (listAdvertisementController.adsList[i].id == id) {
        listAdvertisementController.adsList.value.removeAt(i);
        break;
      }
    }
    await tokenProvider.api
        .put(baseUrl + 'Advertisement/changeTopublished/$id');
  }

  Future<List<Advertisement>> getUserAdvertisement(String userId) async {
    var response;

    response = await tokenProvider.api
        .get(baseUrl + 'Advertisement/getUnpublishedUserAds/$userId');

    var myMap = response.data;
    List<Advertisement> myads = [];
    myMap.forEach(
      (element) {
        myads.add(
          Advertisement(
            id: element['id'],
            title: element['title'],
            description: element['description'],
            datePosted: element['daySended'],
            price: element['price'].toString(),
            photo1: element['photo1'],
            photo2: element['photo2'],
            area: element['area'].toString(),
            userId: element['userId'],
            adsType: element['adsType'],
            published: element['published'],
          ),
        );
      },
    );

    listAdvertisementController.adsList.value = myads;

    return myads;
  }

  Future<List<Advertisement>> getAllUnpublished() async {
    var response;

    response =
        await tokenProvider.api.get(baseUrl + 'Advertisement/getUnpublished');

    var myMap = response.data;
    List<Advertisement> myads = [];
    myMap.forEach(
      (element) {
        myads.add(
          Advertisement(
            id: element['id'],
            title: element['title'],
            description: element['description'],
            datePosted: element['daySended'],
            price: element['price'].toString(),
            photo1: element['photo1'],
            photo2: element['photo2'],
            area: element['area'].toString(),
            userId: element['userId'],
            adsType: element['adsType'],
            published: element['published'],
          ),
        );
      },
    );

    listAdvertisementController.adsList.value = myads;

    return myads;
  }
}
