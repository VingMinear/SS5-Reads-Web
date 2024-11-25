import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/category.dart';
import 'package:homework3/model/imagemodel.dart';
import 'package:homework3/modules/admin/product/controller/CardPhoto.dart';
import 'package:homework3/modules/profile/screens/add_address_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/CustomButton.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:iconsax/iconsax.dart';

class EditingCategoryScreen extends StatefulWidget {
  const EditingCategoryScreen({super.key});

  @override
  State<EditingCategoryScreen> createState() => _EditingCategoryScreenState();
}

class _EditingCategoryScreenState extends State<EditingCategoryScreen> {
  var listCategory = <Category>[].obs;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadingDialog();
      await con.fetchCategory();
      onSet();
      popLoadingDialog();
    });
    super.initState();
  }

  onSet() {
    listCategory.clear();
    for (var e in GlobalClass().homeCategries) {
      listCategory.add(e);
    }
  }

  var con = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => AnimationLimiter(
          child: RefreshIndicator(
            onRefresh: () async {
              await con.fetchCategory();
              onSet();
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
                        "Categories",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      CustomButton(
                        onPress: () {
                          onEdit(context, Category.instance(), isEdit: false);
                        },
                        title: 'Create',
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(15),
                    itemCount: listCategory.length,
                    itemBuilder: (context, index) {
                      var cate = listCategory[index];
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
                                      imgUrl: cate.icon.image.value,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    cate.title,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  const Spacer(),
                                  FloatingActionButton.small(
                                    heroTag: null,
                                    onPressed: () {
                                      onEdit(context, cate, isEdit: true);
                                    },
                                    elevation: 0,
                                    child: const Icon(Iconsax.edit_2),
                                  ),
                                  const SizedBox(width: 10),
                                  FloatingActionButton.small(
                                    onPressed: () {
                                      alertDialogConfirmation(
                                        desc:
                                            'Are you sure you want to delete category?',
                                        title: 'Informations',
                                        onConfirm: () async {
                                          router.pop();
                                          loadingDialog();
                                          await con
                                              .deleteCategory(
                                                  categoryId: cate.id)
                                              .then((value) {
                                            if (value) {
                                              showTaost(
                                                  'Category has been deleled');
                                              onSet();
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

  void onEdit(BuildContext context, Category cate, {required bool isEdit}) {
    var txtCategory = TextEditingController(text: cate.title);
    var img = cate.icon;
    showAlertDialog(
      context: context,
      content: Container(
        decoration: BoxDecoration(
          boxShadow: shadow,
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(builder: (context, rebuild) {
              return Column(
                children: [
                  customAppBar(
                    backgroundColor: Colors.transparent,
                    title: "${isEdit ? 'Edit' : "Add"} Category",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0).copyWith(top: 5),
                    child: Column(
                      children: [
                        FadeInLeft(
                          from: 5,
                          child: CardPhoto(
                            image: img,
                            onPhotoPicker: (path) {
                              img = ImageModel.uploadImageWeb(path!);
                              rebuild(() {});
                            },
                            onClear: () {
                              img = ImageModel.instance;
                              rebuild(() {});
                            },
                          ),
                        ),
                        buildField(
                          controller: txtCategory,
                          title: 'Category Name :',
                          hintText: 'Category Name :',
                        ),
                        const SizedBox(height: 5),
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
                                    txtCategory.clear();
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
                                    var txt = txtCategory.text.trim();

                                    if (txt.isNotEmpty) {
                                      router.pop();
                                      loadingDialog();
                                      if (isEdit) {
                                        await con.updateCategory(
                                          categoryId: cate.id,
                                          categoryName: txt,
                                          img: img,
                                        );
                                      } else {
                                        await con.addCategory(
                                          title: txt,
                                          img: img,
                                        );
                                      }

                                      listCategory.clear();
                                      showTaost(
                                        isEdit
                                            ? 'Category has been updated'
                                            : 'Category has been added',
                                      );
                                      onSet();
                                      popLoadingDialog();
                                    } else {
                                      alertDialog(
                                        desc:
                                            'Please input all required* field',
                                      );
                                    }
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
