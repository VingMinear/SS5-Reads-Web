import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homework3/model/address_model.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/SingleTon.dart';

import '../../../model/address.dart';
import '../../../utils/Utilty.dart';
import '../../../utils/api_base_helper.dart';

class AddressController extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();
  var loading = false.obs;
  var listAddress = <AddressModel>[].obs;
  Future<void> getAddress() async {
    loading(true);
    try {
      await _apiBaseHelper.onNetworkRequesting(
          url: 'get-address',
          methode: METHODE.post,
          body: {
            'customer_id': GlobalClass().userId,
          }).then((value) {
        listAddress.clear();
        if (value['code'] == 200) {
          for (var item in value['data']) {
            listAddress.add(AddressModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getAddress this is error : >> $error',
      );
    }
    loading(false);
  }

  Future<void> addAddress(
    Address address,
  ) async {
    loadingDialog();
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'add-address',
        methode: METHODE.post,
        body: {
          "customer_id": GlobalClass().userId,
          "receiver_name": address.receiverName,
          "phone_number": address.ph,
          "province": address.province,
          "district": address.district,
          "commune": address.commune,
          "house": address.house,
          "longitude": address.longitude,
          "latitude": address.latitude
        },
      ).then((value) async {
        if (value['code'] == 200) {
          await getAddress();
          showTaost('Address has been added');
          router.pop();
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when addAddress this is error : >> $error',
      );
    }
    popLoadingDialog();
  }

  Future<void> updAddress(Address address, int id) async {
    loadingDialog();
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'upd-address',
        methode: METHODE.post,
        body: {
          "id": id,
          "receiver_name": address.receiverName,
          "phone_number": address.ph,
          "province": address.province,
          "district": address.district,
          "commune": address.commune,
          "house": address.house,
        },
      ).then((value) async {
        if (value['code'] == 200) {
          await getAddress();
          showTaost('Address has been updated');
          router.pop();
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when updAddress this is error : >> $error',
      );
    }
    popLoadingDialog();
  }

  Future<void> deleleAddress(
    int id,
  ) async {
    loadingDialog();
    try {
      await _apiBaseHelper.onNetworkRequesting(
          url: 'delete-address',
          methode: METHODE.post,
          body: {"id": id}).then((value) async {
        if (value['code'] == 200) {
          await getAddress();
          router.pop();
          showTaost('Address has been deleted');
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when deleleAddress this is error : >> $error',
      );
    }
    popLoadingDialog();
  }
}
