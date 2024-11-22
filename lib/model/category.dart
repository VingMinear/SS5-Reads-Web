import 'dart:developer';
import 'package:get/get.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/modules/admin/product/controller/adproduct_con.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/api_base_helper.dart';

class Category {
  Category(this.icon, this.title, this.id);
  ImageModel icon = ImageModel.instance;
  String title = '';
  int id = 0;
  Category.instance();
  Category.fromJson(Map json) {
    title = json["category_name"] ?? '';
    id = json['id'] ?? '';
    if (json['image'] != null && json['image'].isNotEmpty) {
      icon = ImageModel(
          image: RxString("${json['image']}"),
          name: 'icon',
          photoViewBy: PhotoViewBy.network);
    }
  }
}

class CategoryController extends GetxController {
  RxList<Category> get homeCategries => GlobalClass().homeCategries;
  final _apiBaseHelper = ApiBaseHelper();
  Future<void> fetchCategory() async {
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'category',
        methode: METHODE.post,
        body: {},
      ).then((value) {
        if (value['code'] == 200) {
          homeCategries.clear();
          for (var item in value['data']) {
            homeCategries.add(Category.fromJson(item));
          }
        }
      });
      homeCategries;
    } catch (error) {
      log(
        'CatchError while fetchCategory ( error message ) : >> $error',
      );
    }
  }

  Future<bool> updateCategory({
    required int categoryId,
    required String categoryName,
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
        url: 'update-category',
        methode: METHODE.post,
        body: {'id': categoryId, "category_name": categoryName, "image": image},
      ).then((value) async {
        if (value['code'] == 200) {
          isSuccess = true;
          await fetchCategory();
        }
      });
    } catch (error) {
      log(
        'CatchError while updateCategory ( error message ) : >> $error',
      );
    }
    return isSuccess;
  }

  Future<bool> deleteCategory({required int categoryId}) async {
    bool isSuccess = false;
    try {
      await _apiBaseHelper.onNetworkRequesting(
        url: 'delete-category',
        methode: METHODE.post,
        body: {
          'id': categoryId,
        },
      ).then((value) async {
        if (value['code'] == 200) {
          isSuccess = true;
          await fetchCategory();
        }
      });
    } catch (error) {
      log(
        'CatchError while deleteCategory ( error message ) : >> $error',
      );
    }
    return isSuccess;
  }

  Future<bool> addCategory({
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
        url: 'add-category',
        methode: METHODE.post,
        body: {
          "category_name": title,
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
    await fetchCategory();
    return isSuccess;
  }
}

class CategoryModel {
  String name = 'Defualt';
  bool use = true;
  String id = '';

  CategoryModel();
  CategoryModel.fromJson(Map json, String id);
}
