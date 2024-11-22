import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImagePickerProvider extends GetxController {
  static init() => Get.put(ImagePickerProvider());
  var loadingUpdageImage = false.obs;
  var imageUrl = "".obs;

  Future<String> pickImage(
      {required ImageSource source,
      required bool updateProfile,
      required String userId}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return "";
      var filePath = (await compressImage(image.path));
      imageUrl.value = filePath.path;
    } on PlatformException catch (error) {
      debugPrint(
        'CatchError when pickImage this is error : >> $error',
      );
    }
    return imageUrl.value;
  }

  Future<XFile> compressImage(String path) async {
    final newPath =
        p.join((await getTemporaryDirectory()).path, '${DateTime.now()}.jpg');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath);
    return result!;
  }
}
