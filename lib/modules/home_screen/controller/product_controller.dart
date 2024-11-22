import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/model/product_varaint.dart';

import '../../../model/product_model.dart';
import '../../../utils/SingleTon.dart';
import '../../../utils/api_base_helper.dart';

class ProductController extends GetxController {
  // var productDetail = ProductModel().obs;
  var loading = false.obs;
  final _apiBaseHelper = ApiBaseHelper();
  var productsRecommend = <ProductModel>[];
  final listSearch = <String>[];
  var sizeClothes = ProductVariant(
    title: 'Size :',
    listVariants: ['S', 'M', 'L', 'XL'],
  );
  var sizeShoes = ProductVariant(
    title: 'Size :',
    listVariants: ['38', '39', '40', '41'],
  );
  Future<bool> updFavorite({
    required int proId,
    required bool isFav,
  }) async {
    bool success = false;
    try {
      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'upd-favorite',
        body: {
          "customer_id": GlobalClass().userId,
          "product_id": proId,
          "favorite": isFav ? 0 : 1,
        },
        methode: METHODE.post,
      )
          .then((value) async {
        log("data :$value");
        if (value['code'] == 200) {
          success = true;
          // getProductDetail(pId: proId.toString());
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when updProductFavorite this is error : >> $error',
      );
    }
    loading(false);
    return success;
  }

  Future<bool> addFavorite({
    required int proId,
  }) async {
    bool success = false;
    try {
      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'add-favorite',
        body: {
          "customer_id": GlobalClass().userId,
          'favorite': 1,
          "product_id": proId,
        },
        methode: METHODE.post,
      )
          .then((value) async {
        log("data :$value");
        if (value['code'] == 200) {
          success = true;
          // getProductDetail(pId: proId.toString());
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when updProductFavorite this is error : >> $error',
      );
    }
    loading(false);
    return success;
  }

  Future<List<ProductModel>> getAllProducts() async {
    var products = <ProductModel>[];

    try {
      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'products?customer_id=${GlobalClass().userId}',
        methode: METHODE.get,
      )
          .then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            products.add(ProductModel.fromJson(item));
          }
        }
      });
      productsRecommend = products;
    } catch (error) {
      debugPrint(
        'CatchError when getAllProducts this is error : >> $error',
      );
    }
    return products;
  }

  var listRecommentProduct = <ProductModel>[];
  var loadingNewCollection = true.obs;

  Future<void> getCategory() async {
    try {
//  var data= await _apiBaseHelper.onNetworkRequesting(url: , methode: methode);
    } catch (error) {
      log(
        'CatchError while getCategory ( error message ) : >> $error',
      );
    }
  }

  Future<void> getRecommentProducts() async {
    loadingNewCollection(true);
    listRecommentProduct.clear();
    var listPro = <ProductModel>[];
    try {
      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'products?customer_id=${GlobalClass().userId}',
        methode: METHODE.get,
      )
          .then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            listPro.add(ProductModel.fromJson(item));
          }
        }
        listPro.shuffle();
        var isHas = listPro.any((element) => element.sold > 2);
        if (isHas) {
          for (int i = 0; i < listPro.length; i++) {
            if (listPro[i].sold > 2) {
              listRecommentProduct.add(listPro[i]);
            }
          }
        } else {
          listRecommentProduct = listPro.toList();
        }

        productsRecommend = listPro;
        listSearch.clear();
        for (var element in listRecommentProduct) {
          listSearch.add(element.productName!);
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when get recomment product this is error : >> $error',
      );
    }
    loadingNewCollection(false);
  }

  Future<ProductModel> getProductDetail({
    required int pId,
  }) async {
    var result = ProductModel();
    try {
      loading(true);
      await _apiBaseHelper.onNetworkRequesting(
          url: 'products-detail',
          methode: METHODE.post,
          body: {
            "product_id": pId,
            "customer_id": GlobalClass().userId,
          }).then((value) {
        if (value['code'] == 200) {
          result = ProductModel.fromJson(value['data']);
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when this is error : >> $error',
      );
    }
    loading(false);
    return result;
  }

  Future<List<ProductModel>> getProductByCategory({
    required int categoryId,
  }) async {
    var result = <ProductModel>[];
    try {
      await _apiBaseHelper.onNetworkRequesting(
          url: 'products-category',
          methode: METHODE.post,
          body: {
            "category_id": categoryId,
            "customer_id": GlobalClass().userId,
          }).then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            result.add(ProductModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getProductCatgory this is error : >> $error',
      );
    }
    return result;
  }

  Future<List<ProductModel>> getProductBySearch({
    required String productName,
  }) async {
    var result = <ProductModel>[];
    try {
      loading(true);
      await _apiBaseHelper.onNetworkRequesting(
          url:
              'products?customer_id=${GlobalClass().userId}&&search=${productName.trim()}',
          methode: METHODE.get,
          body: {}).then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            result.add(ProductModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getProductBysearch this is error : >> $error',
      );
    }
    loading(false);
    return result;
  }
}
