import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/utils/NumExtension.dart';
import 'package:homework3/utils/UploadImageWeb.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';

class CardPhoto extends StatelessWidget {
  const CardPhoto(
      {super.key,
      required this.onPhotoPicker,
      required this.image,
      required this.onClear});

  final Function(PlatformFile? path) onPhotoPicker;
  final Function() onClear;
  final ImageModel image;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: image.bytes != null
            ? null
            : () async {
                PlatformFile? path;

                path = await UploadImageWeb().singleImage();
                onPhotoPicker(path);
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: image.bytes != null || image.image.value.isNotEmpty
                  ? Colors.transparent
                  : Colors.black12,
            ),
            color: image.bytes != null || image.image.value.isNotEmpty
                ? Colors.black12
                : Colors.transparent,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          width: 120.scale,
          height: 120.scale,
          child: image.bytes != null || image.image.value.isNotEmpty
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: image.photoViewBy == PhotoViewBy.network
                          ? CustomCachedNetworkImage(imgUrl: image.image.value)
                          : Image.memory(image.bytes!, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: onClear,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.bgScaffold.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 17,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.grey),
                    SizedBox(height: 5),
                    Text(
                      "Click to add image.",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
        ),
      );
    });
  }
}
