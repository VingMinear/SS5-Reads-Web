import 'package:file_picker/file_picker.dart';

import 'Log.dart';

///   Package needed:
///   flutter_image_compress:
///   image_picker:
///   permission_handler:
///   dont forget to add permission for android and ios (*ios includes in podfile)
class UploadImageWeb {
  Future<PlatformFile?> singleImage() async {
    PlatformFile? file;
    try {
      var picked = await FilePicker.platform.pickFiles(
          allowMultiple: false, type: FileType.image, compressionQuality: 50);

      if (picked != null) {
        file = picked.files.first;
      }
    } catch (e) {
      Log.error("Error while pick single image $e");
    }
    return file;
  }
}
