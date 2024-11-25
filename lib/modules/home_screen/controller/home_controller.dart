import 'dart:developer';

import 'package:get/get.dart';
import 'package:homework3/model/slide_model.dart';

import '../../../utils/api_base_helper.dart';

class HomeController extends GetxController {
  var slidesBanner = <SlideModel>[].obs;
  final _apiBaseHelper = ApiBaseHelper();
  var loading = false.obs;
  Future<List<SlideModel>> fetchslides() async {
    try {
      loading(true);
      slidesBanner.clear();
      await _apiBaseHelper.onNetworkRequesting(
        url: 'slides',
        methode: METHODE.post,
        body: {},
      ).then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            slidesBanner.add(SlideModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      log(
        'CatchError while fetchslides ( error message ) : >> $error',
      );
    }
    loading(false);

    return slidesBanner;
  }
}
