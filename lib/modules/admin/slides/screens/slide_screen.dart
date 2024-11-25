import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/model/slide_model.dart';
import 'package:homework3/modules/admin/product/controller/CardPhoto.dart';
import 'package:homework3/modules/admin/slides/controller/SlideController.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/CustomButton.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:iconsax/iconsax.dart';

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
      body: Obx(
        () => AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              await con.fetchslides();
            },
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Text(
                        "Slides show",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      CustomButton(
                        onPress: () {
                          onEdit(context, SlideModel(), isEdit: false);
                        },
                        title: 'Create',
                      )
                    ],
                  ),
                ),
                Expanded(
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
                                    elevation: 0,
                                    child: const Icon(Iconsax.edit_2),
                                  ),
                                  const SizedBox(width: 10),
                                  FloatingActionButton.small(
                                    onPressed: () {
                                      alertDialogConfirmation(
                                        desc:
                                            'Are you sure you want to delete Slide?',
                                        title: 'Informations',
                                        onConfirm: () async {
                                          router.pop();
                                          loadingDialog();
                                          await con
                                              .deleteslides(slidesId: slide.id)
                                              .then((value) {
                                            if (value) {
                                              showTaost(
                                                  'Slide has been deleted');
                                            }
                                          });
                                          popLoadingDialog();
                                        },
                                      );
                                    },
                                    heroTag: null,
                                    backgroundColor: Colors.red.shade600,
                                    elevation: 0,
                                    child: const Icon(Iconsax.trash),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEdit(BuildContext context, SlideModel cate, {required bool isEdit}) {
    var img = cate.img;
    showAlertDialog(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatefulBuilder(builder: (context, rebuild) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: shadow,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  customAppBar(
                    backgroundColor: Colors.white,
                    title: "${isEdit ? 'Edit' : "Add"} Slide show",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0).copyWith(top: 5),
                    child: Column(
                      children: [
                        FadeInLeft(
                          from: 5,
                          child: CardPhoto(
                            onPhotoPicker: (path) {
                              img = ImageModel.uploadImageWeb(path!);
                              rebuild(() {});
                            },
                            image: img,
                            onClear: () {
                              img = ImageModel.instance;
                              rebuild(() {});
                            },
                          ),
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
                                    router.pop();
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
      ),
    );
  }
}
