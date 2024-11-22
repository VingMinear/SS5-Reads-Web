import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/image_model.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/model/slide_model.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_detail.dart';
import 'package:homework3/modules/admin/slides/controller/SlideController.dart';
import 'package:homework3/modules/profile/screens/add_address_screen.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';
import 'package:homework3/utils/image_picker.dart';
import 'package:homework3/widgets/CustomButton.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/PhotoViewDetail.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class SlideScreen extends StatefulWidget {
  const SlideScreen({super.key});

  @override
  State<SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadingDialog();
      await con.fetchslides();

      popLoadingDialog();
    });
    super.initState();
  }

  var con = Get.put(SlideController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Edit Slide',
      ),
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              await con.fetchslides();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: con.slidesBanner.length,
              itemBuilder: (context, index) {
                var slide = con.slidesBanner[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: FadeInAnimation(
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10)
                            .copyWith(left: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffFEFEFE),
                          boxShadow: shadow,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 55,
                              height: 55,
                              child: CustomCachedNetworkImage(
                                imgUrl: slide.img.image.value,
                              ),
                            ),
                            const Spacer(),
                            FloatingActionButton.small(
                              heroTag: null,
                              onPressed: () {
                                onEdit(context, slide, isEdit: true);
                              },
                              elevation: 2,
                              child: const Icon(Iconsax.edit_2),
                            ),
                            FloatingActionButton.small(
                              onPressed: () {
                                alertDialogConfirmation(
                                  desc:
                                      'Are you sure you want to delete Slide?',
                                  title: 'Informations',
                                  onConfirm: () async {
                                    Get.back();
                                    loadingDialog();
                                    await con
                                        .deleteslides(slidesId: slide.id)
                                        .then((value) {
                                      if (value) {
                                        showTaost('Slide has been deleted');
                                      }
                                    });
                                    popLoadingDialog();
                                  },
                                );
                              },
                              heroTag: null,
                              backgroundColor: Colors.red.shade600,
                              elevation: 2,
                              child: const Icon(Iconsax.trash),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 15),
            ),
          ),
        ),
      ),
      floatingActionButton: ZoomIn(
        duration: const Duration(milliseconds: 180),
        child: FloatingActionButton(
          heroTag: 'cute',
          onPressed: () {
            onEdit(context, SlideModel(), isEdit: false);
          },
          tooltip: "Edit",
          elevation: 2,
          child: const Icon(Iconsax.edit_2),
        ),
      ),
    );
  }

  void onEdit(BuildContext context, SlideModel cate, {required bool isEdit}) {
    var img = cate.img;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) {
        var height = MediaQuery.of(context).viewInsets.bottom;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(builder: (context, rebuild) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: height * 0.8,
                ),
                child: Column(
                  children: [
                    customAppBar(
                      useLeadingCustom: false,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.clear_rounded, size: 30),
                      ),
                      title: "${isEdit ? 'Edit' : "Add"} Slide",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0).copyWith(top: 5),
                      child: Column(
                        children: [
                          FadeInLeft(
                            from: 5,
                            child: Obx(() {
                              return img.image.value.isEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        dismissKeyboard(context);
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return cupertinoModal(context,
                                                (index) async {
                                              Get.back();

                                              await ImagePickerProvider()
                                                  .pickImage(
                                                      source: index == 0
                                                          ? ImageSource.gallery
                                                          : ImageSource.camera,
                                                      updateProfile: false,
                                                      userId: '')
                                                  .then((value) {
                                                if (value.isNotEmpty) {
                                                  img = ImageModel(
                                                    image: value.obs,
                                                    name: "product",
                                                    photoViewBy:
                                                        PhotoViewBy.file,
                                                  );
                                                  rebuild(() {});
                                                }
                                              });
                                            });
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 180,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: shadow,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey.shade100,
                                        ),
                                        alignment: Alignment.center,
                                        child: const Icon(CupertinoIcons.add),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        Get.to(
                                          () => PhotoViewDetail(
                                            imageUrl: img.image.value,
                                            viewByUrl: img.photoViewBy ==
                                                PhotoViewBy.network,
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 180,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              boxShadow: shadow,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: grey.withOpacity(0.4),
                                              image: img.photoViewBy ==
                                                      PhotoViewBy.network
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                        "$baseurl/${img.image.value}",
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image: FileImage(File(
                                                        img.image.value,
                                                      )),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                img = ImageModel.instance;
                                                rebuild(() {});
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            }),
                          ),
                          // buildField(
                          //   controller: txtSlide,
                          //   title: 'Slide Name :',
                          //   hintText: 'Slide Name :',
                          // ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: FadeInLeft(
                                  from: 5,
                                  child: CustomButton(
                                    borderSide:
                                        BorderSide(color: Colors.red.shade300),
                                    backgroundColor: Colors.red.shade600,
                                    textStyle: context.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white),
                                    title: 'Clear',
                                    onPress: () {
                                      // txtSlide.clear();
                                      img = ImageModel.instance;
                                      rebuild(() {});
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: FadeInLeft(
                                  from: 5,
                                  child: CustomButton(
                                    borderSide:
                                        const BorderSide(color: mainColor),
                                    title: 'Save',
                                    onPress: () async {
                                      // var txt = txtSlide.text.trim();
                                      Get.back();
                                      loadingDialog();
                                      if (isEdit) {
                                        await con.updateslides(
                                          slidesId: cate.id,
                                          slidesName: '',
                                          img: img,
                                        );
                                      } else {
                                        await con.addslides(
                                          title: '',
                                          img: img,
                                        );
                                      }

                                      showTaost(
                                        isEdit
                                            ? 'Slide has been updated'
                                            : 'Slide has been added',
                                      );

                                      popLoadingDialog();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
