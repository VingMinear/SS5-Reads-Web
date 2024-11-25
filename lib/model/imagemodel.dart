import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'image_model.dart';

class ImageModel {
  RxString image = ''.obs;
  Uint8List? bytes;
  String name = '';
  PhotoViewBy photoViewBy = PhotoViewBy.file;

  static ImageModel get instance =>
      ImageModel(image: ''.obs, name: '', photoViewBy: PhotoViewBy.file);
  ImageModel(
      {required this.image, required this.name, required this.photoViewBy});
  ImageModel.copy(ImageModel model)
      : image = RxString(model.image.value),
        bytes = model.bytes,
        name = model.name,
        photoViewBy = model.photoViewBy;

  ImageModel.fromNetwork(String img) {
    image(img);
    photoViewBy = PhotoViewBy.network;
  }
  ImageModel.uploadImageWeb(PlatformFile file) {
    bytes = file.bytes!;
    name = file.name;
    image(file.name);
    photoViewBy = PhotoViewBy.file;
  }

  ImageModel.fromUpload({
    required this.image,
    required this.name,
    required this.photoViewBy,
  });
}
