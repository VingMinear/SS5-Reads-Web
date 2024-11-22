import 'package:get/get.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';

class SlideModel {
  String title = '';
  ImageModel img = ImageModel.instance;
  int id = 0;

  SlideModel();
  SlideModel.fromJson(Map json) {
    title = json['title'] ?? '';
    if (json['image'] != null && json['image'].isNotEmpty) {
      img = ImageModel(
        image: RxString("${json['image']}"),
        name: 'image',
        photoViewBy: PhotoViewBy.network,
      );
    }
    id = json['id'] ?? 0;
  }
}
