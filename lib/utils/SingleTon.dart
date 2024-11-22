// for store data temporary

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homework3/model/category.dart';

import '../model/user_model.dart';
import 'LocalStorage.dart';

class GlobalClass {
  static final GlobalClass _singleton = GlobalClass._internal();

  factory GlobalClass() {
    return _singleton;
  }
  var isMapOff = false.obs;
  var user = UserModel().obs;
  get userId => GlobalClass().user.value.id;
  bool get isUserLogin => LocalStorage.getStringData(key: 'token').isNotEmpty;
  String deviceId = '';
  LatLng? latlng;
  var homeCategries = <Category>[].obs;
  GlobalClass._internal();
}
