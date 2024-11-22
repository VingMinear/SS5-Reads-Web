import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/profile/controller/profile_controller.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/PhotoViewDetail.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/SingleTon.dart';
import '../../../utils/image_picker.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    var user = GlobalClass().user;
    log("Pho ${user.value.photo}");

    return Obx(
      () => IntrinsicHeight(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CustomCachedNetworkImage(
                    imgUrl: user.value.photo,
                  ),
                ),
                const VerticalDivider(
                  color: Colors.grey,
                  width: 15,
                  endIndent: 3,
                  indent: 3,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.value.name ?? 'Unkown',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        user.value.email ?? "SS5@example.com",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget cupertinoModal(BuildContext context, {Function()? setState}) {
  var user = GlobalClass().user.value;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_cupertino.length, (index) {
        return ListTile(
          onTap: () async {
            Get.back();
            var userId = LocalStorage.getStringData(key: 'user_id');
            switch (index) {
              case 0:
                Get.to(
                  PhotoViewDetail(imageUrl: user.photo),
                );
                break;
              default:
                var res = await ImagePickerProvider().pickImage(
                  source: index == 1 ? ImageSource.gallery : ImageSource.camera,
                  updateProfile: true,
                  userId: userId,
                );
                if (res.isNotEmpty) {
                  loadingDialog();
                  await ProfileController().updatePhoto(img: res);
                  if (setState != null) setState();
                  popLoadingDialog();
                }
                break;
            }
          },
          title: Text(_cupertino[index].title!),
          leading: _cupertino[index].icon,
        );
      }),
    ),
  );
}

List<CupertinoItem> _cupertino = [
  CupertinoItem(
    title: 'View Photo',
    icon: const Icon(CupertinoIcons.photo),
  ),
  CupertinoItem(
    title: 'Upload Photo',
    icon: const Icon(CupertinoIcons.cloud_upload),
  ),
  CupertinoItem(
    title: 'Camera',
    icon: const Icon(CupertinoIcons.camera),
  ),
];

class CupertinoItem {
  String? title;
  Icon? icon;

  CupertinoItem({
    this.title,
    this.icon,
  });
}
