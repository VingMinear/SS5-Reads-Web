import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'image_model.dart';

class ImageModel {
  RxString image = ''.obs;
  String name = '';
  PhotoViewBy photoViewBy = PhotoViewBy.file;
  static ImageModel get instance =>
      ImageModel(image: ''.obs, name: '', photoViewBy: PhotoViewBy.file);
  ImageModel(
      {required this.image, required this.name, required this.photoViewBy});
  ImageModel copy(ImageModel model) {
    return ImageModel(
      image: model.image,
      name: model.name,
      photoViewBy: model.photoViewBy,
    );
  }

  ImageModel.fromUpload(
      {required this.image, required this.name, required this.photoViewBy});
}
