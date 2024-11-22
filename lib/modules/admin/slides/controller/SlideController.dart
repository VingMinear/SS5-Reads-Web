import 'dart:developer';

import 'package:get/get.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/model/slide_model.dart';
import 'package:homework3/modules/admin/product/controller/adproduct_con.dart';
import 'package:homework3/utils/api_base_helper.dart';

class SlideController extends GetxController {
  @override
  void onInit() {
    // getAllProducts();
    super.onInit();
  }

  var slidesBanner = <SlideModel>[].obs;
  final _apiBaseHelper = ApiBaseHelper();
  Future<void> fetchslides() async {
    try {
      var tmp = <SlideModel>[];
      await _apiBaseHelper.onNetworkRequesting(
        url: 'slides',
        methode: METHODE.post,
        body: {},
      ).then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            tmp.add(SlideModel.fromJson(item));
          }
        }
        slidesBanner.value = tmp;
      });
    } catch (error) {
      log(
        'CatchError while fetchslides ( error message ) : >> $error',
      );
    }
  }

  Future<bool> updateslides({
    required int slidesId,
    required String slidesName,
    required ImageModel img,
  }) async {
    var image = img.image.value.replaceAll("${baseurl}image/", '');
    if (img.photoViewBy == PhotoViewBy.file && img.image.value.isNotEmpty) {
      await AdminProductController().uploadPhoto(image).then((value) {
        image = value;
      });
    }
    bool isSuccess = false;
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'update-slides',
        methode: METHODE.post,
        body: {'id': slidesId, "title": slidesName, "image": image},
      ).then((value) async {
        if (value['code'] == 200) {
          isSuccess = true;
          await fetchslides();
        }
      });
    } catch (error) {
      log(
        'CatchError while updateslides ( error message ) : >> $error',
      );
    }
    return isSuccess;
  }

  Future<bool> deleteslides({required int slidesId}) async {
    bool isSuccess = false;
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'delete-slides',
        methode: METHODE.post,
        body: {
          'id': slidesId,
        },
      ).then((value) async {
        if (value['code'] == 200) {
          isSuccess = true;
          await fetchslides();
        }
      });
    } catch (error) {
      log(
        'CatchError while deleteslides ( error message ) : >> $error',
      );
    }
    return isSuccess;
  }

  Future<bool> addslides({
    required String title,
    required ImageModel img,
  }) async {
    bool isSuccess = false;
    try {
      var image = '';
      if (img.photoViewBy == PhotoViewBy.file) {
        await AdminProductController()
            .uploadPhoto(img.image.value)
            .then((value) => image = value);
      }
      await _apiBaseHelper.onNetworkRequesting(
        url: 'add-slides',
        methode: METHODE.post,
        body: {
          "title": title,
          "image": image,
        },
      ).then((value) async {
        if (value['code'] == 200) {
          isSuccess = true;
        }
      });
    } catch (error) {
      log(
        'CatchError while addCateogry ( error message ) : >> $error',
      );
    }
    await fetchslides();
    return isSuccess;
  }
}
