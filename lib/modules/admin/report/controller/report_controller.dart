import 'dart:developer';

import 'package:get/get.dart';

import '../../../../model/report_model.dart';
import '../../../../utils/api_base_helper.dart';
import '../../user/controller/admin_user_con.dart';

class ReportController extends GetxController {
  final _apiBaseHelper = ApiBaseHelper();
  var listReport = <ReportModel>[].obs;
  var loading = false.obs;
  var totalUser = 0;
  var stock = 0.0;
  Future<void> fetchReportMenu() async {
    try {
      await AdminUserCon().fetchCustomer().then((value) {
        totalUser = value.length;
      });
      await fetchStockProduct();
    } catch (e) {
      log("error fetch report menu");
    }
  }

  Future<void> fetchStockProduct() async {
    try {
      var body = <String, dynamic>{"search": ''};
      var url = 'products';

      await _apiBaseHelper
          .onNetworkRequesting(
        url: url,
        body: body,
        methode: METHODE.post,
      )
          .then((value) {
        if (value['code'] == 200) {
          stock = value['data'].length;
        }
      });
    } catch (error) {
      log(
        'CatchError while fetchStockProduct ( error message ) : >> $error',
      );
    }
  }

  Future<void> onRefresh() async {
    try {
      loading(true);
      await fetchReportList();
      await fetchReportMenu();
    } catch (error) {
      log(
        'CatchError while onRefresh ( error message ) : >> $error',
      );
    }
    loading(false);
  }

  Future<void> fetchReportList() async {
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'admin-report',
        methode: METHODE.post,
        body: {},
      ).then((value) {
        listReport.clear();
        if (value['code'] == 200) {
          for (var item in value['data']) {
            listReport.add(ReportModel.fromJson(item));
          }
        }
      });
    } catch (e) {
      log("error fetch report menu");
    }
  }
}
