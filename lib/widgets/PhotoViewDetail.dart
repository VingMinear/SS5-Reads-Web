import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/utils/api_base_helper.dart';
import 'package:photo_view/photo_view.dart';

import '../model/user_model.dart';

class PhotoViewDetail extends StatelessWidget {
  const PhotoViewDetail({
    super.key,
    required this.imageUrl,
    this.viewByUrl = true,
  });
  final String imageUrl;
  final bool viewByUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: 70,
        leading: IconButton(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shadowColor: grey,
            backgroundColor: whiteColor,
          ),
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.clear_outlined,
            size: 25,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: viewByUrl
            ? PhotoView(
                gaplessPlayback: true,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 5,
                imageProvider: imageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(
                        '$baseurl$imageUrl',
                      )
                    : const CachedNetworkImageProvider(
                        defualtImage,
                      ),
              )
            : PhotoView(
                gaplessPlayback: true,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 5,
                imageProvider: FileImage(File(imageUrl)),
              ),
      ),
    );
  }
}
