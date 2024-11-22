import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/api_base_helper.dart';
import 'package:homework3/widgets/PhotoViewDetail.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/input_field.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/category.dart';
import '../../../../model/image_model.dart';
import '../../../../model/imagemodel.dart';
import '../../../../utils/image_picker.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../../widgets/CustomDropdownFormField.dart';
import '../controller/adproduct_con.dart';

class AdminProductDetail extends StatefulWidget {
  const AdminProductDetail(
      {super.key, required this.isEdit, required this.pId});
  final int pId;
  final bool isEdit;
  @override
  State<AdminProductDetail> createState() => _AdminProductDetailState();
}

class _AdminProductDetailState extends State<AdminProductDetail> {
  var txtProNameCon = TextEditingController();
  var txtPricein = TextEditingController();
  var txtPriceOut = TextEditingController();
  var txtQty = TextEditingController();
  var imageAsset = ImageModel.instance.obs;
  var proCon = Get.put(AdminProductController());
  void onReset() {
    cate = null;
    txtProNameCon = TextEditingController();
    txtPricein = TextEditingController();
    txtQty = TextEditingController();
    txtPriceOut.clear();
    imageAsset = ImageModel.instance.obs;
  }

  var loading = false.obs;
  Category? cate;
  var listCategory = <Category>[];
  ProductModel result = ProductModel();
  @override
  void initState() {
    for (var element in proCon.listCategory) {
      if (element.id != 0) listCategory.add(element);
    }
    if (widget.isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        loading(true);
        result = await proCon.getProductDetail(pId: widget.pId);
        txtProNameCon.text = result.productName ?? '';
        txtPricein.text = result.priceIn.toString();
        txtPriceOut.text = result.priceOut.toString();
        txtQty.text = result.qty.toString();
        for (var cate in listCategory) {
          if (result.categoryId == cate.id) {
            this.cate = cate;
          }
        }
        var img = result.image ?? '';
        imageAsset.value = ImageModel(
          image: img.obs,
          name: img,
          photoViewBy: PhotoViewBy.network,
        );
        loading(false);
        // setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: customAppBar(
          title: widget.isEdit ? 'Edit Product' : "Create Product",
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: loading.value
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: mainColor,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    __buildField(
                      controller: txtProNameCon,
                      title: 'Product name',
                      hintText: 'Product name',
                    ),
                    FadeInLeft(
                      from: 10,
                      child: const Row(
                        children: [
                          Text('Category'),
                          Text(
                            " *",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeInLeft(
                      from: 5,
                      child: CustomDropdownFormField(
                        onChanged: (value) {
                          cate = value!;
                        },
                        cate: cate,
                        list: listCategory,
                        hint: 'Category',
                        backgroundColor: grey.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: __buildField(
                            controller: txtPricein,
                            title: 'Price In',
                            hintText: 'Price In',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: __buildField(
                            controller: txtPriceOut,
                            title: 'Price Out',
                            hintText: 'Price Out',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        FadeInLeft(
                          from: 5,
                          child: Obx(() {
                            return imageAsset.value.image.isEmpty
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
                                                imageAsset(ImageModel(
                                                  image: value.obs,
                                                  name: "product",
                                                  photoViewBy: PhotoViewBy.file,
                                                ));
                                              }
                                            });
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: appWidth() * 0.4,
                                      width: appWidth() * 0.4,
                                      decoration: BoxDecoration(
                                        boxShadow: shadow,
                                        borderRadius: BorderRadius.circular(12),
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
                                          imageUrl:
                                              imageAsset.value.image.value,
                                          viewByUrl:
                                              imageAsset.value.photoViewBy ==
                                                  PhotoViewBy.network,
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          decoration: BoxDecoration(
                                            boxShadow: shadow,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: grey.withOpacity(0.4),
                                            image:
                                                imageAsset.value.photoViewBy ==
                                                        PhotoViewBy.network
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                          "$baseurl${imageAsset.value.image.value}",
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : DecorationImage(
                                                        image: FileImage(File(
                                                          imageAsset.value.image
                                                              .value,
                                                        )),
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              imageAsset.value =
                                                  ImageModel.instance;
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                                VisualDensity.compact,
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.white,
                                              size: 19,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          }),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              __buildField(
                                controller: txtQty,
                                title: 'Qty',
                                hintText: 'Qty',
                                keyboardType: TextInputType.number,
                                inputFormatters: [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        floatingActionButton: loading.value
            ? null
            : widget.isEdit
                ? FloatingActionButton(
                    onPressed: () {
                      alertDialogConfirmation(
                        title: 'Information',
                        desc: 'Are you sure you want to delete this product ?'
                            .tr, //You want to delete this product ?
                        onConfirm: () async {
                          Get.back();
                          loadingDialog();
                          await proCon
                              .deleteProduct(pid: widget.pId)
                              .then((value) {
                            if (value) {
                              showTaost(
                                  'Product has been deleted successfully✅');
                              Get.back();
                            }
                          });
                          popLoadingDialog();
                        },
                        txtBtnCfn: 'Confirm',
                      );
                    },
                    elevation: 4,
                    shape: const CircleBorder(),
                    backgroundColor: Colors.red.shade600,
                    child: const Icon(Iconsax.trash),
                  )
                : null,
        bottomNavigationBar: loading.value
            ? null
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        borderSide: BorderSide(color: Colors.red.shade600),
                        backgroundColor: Colors.red.shade600,
                        textStyle: context.textTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                        title: 'Clear'.tr,
                        onPress: () {
                          onReset();
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        borderSide: const BorderSide(color: mainColor),
                        title: widget.isEdit ? 'Save' : 'Add',
                        textStyle: context.textTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                        onPress: () async {
                          var proName = txtProNameCon.text.trim();
                          var priceIn = txtPricein.text.trim();
                          var priceout = txtPriceOut.text.trim();
                          var qty = txtQty.text.trim();
                          if (proName.isNotEmpty &&
                              priceIn.isNotEmpty &&
                              priceout.isNotEmpty &&
                              qty.isNotEmpty &&
                              cate != null) {
                            if (double.parse(priceIn) != 0.0 &&
                                double.parse(priceout) != 0.0) {
                              loadingDialog();
                              if (widget.isEdit) {
                                await proCon.updateProduct(
                                  pid: widget.pId,
                                  pname: proName,
                                  priceIn: double.parse(priceIn),
                                  priceout: double.parse(priceout),
                                  qty: int.parse(qty),
                                  image: imageAsset.value,
                                  categoryId: cate?.id ?? 0,
                                );
                              } else {
                                await proCon.addProduct(
                                  pname: proName,
                                  priceIn: double.parse(priceIn),
                                  priceout: double.parse(priceout),
                                  qty: int.parse(qty),
                                  image: imageAsset.value,
                                  categoryId: cate?.id ?? 0,
                                );
                              }
                              popLoadingDialog();
                              Get.back();
                            } else {
                              alertDialog(desc: 'Invalid Input Price');
                            }
                          } else {
                            alertDialog(
                                desc: 'Please input all required field');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Widget __buildField({
  required TextEditingController controller,
  required String title,
  String hintText = '',
  bool isTypeMulti = false,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  TextInputAction? textInputAction,
  bool required = true,
  bool focus = false,
  void Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FadeInLeft(
        from: 10,
        child: Row(
          children: [
            Text(title),
            Text(
              required ? " *" : '',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      FadeInLeft(
        from: 5,
        delay: const Duration(milliseconds: 150),
        child: InputField(
          autofocus: focus,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          animate: false,
          maxLines: isTypeMulti ? 5 : 1,
          hintText: hintText,
          onChanged: onChanged,
          textInputAction: textInputAction,
          controller: controller,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}

Widget cupertinoModal(BuildContext context, void Function(int) callBack,
    {bool isEdit = false}) {
  List<CupertinoItem> cupertino = [
    CupertinoItem(
      title: 'Upload Photo',
      icon: const Icon(CupertinoIcons.cloud_upload),
    ),
    CupertinoItem(
      title: 'Camera',
      icon: const Icon(CupertinoIcons.camera),
    ),
  ];

  if (isEdit) {
    cupertino.insert(
      0,
      CupertinoItem(
        title: 'view_photo'.tr,
        icon: const Icon(CupertinoIcons.photo),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(cupertino.length, (index) {
        return ListTile(
          onTap: () async {
            callBack(index);
          },
          title: Text(cupertino[index].title!),
          leading: cupertino[index].icon,
        );
      }),
    ),
  );
}

class CupertinoItem {
  String? title;
  Icon? icon;

  CupertinoItem({
    this.title,
    this.icon,
  });
}
