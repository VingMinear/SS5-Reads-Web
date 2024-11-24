import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/admin/product/controller/CardPhoto.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/style.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/input_field.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../model/category.dart';
import '../../../../model/image_model.dart';
import '../../../../model/imagemodel.dart';
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
    txtDesc = TextEditingController();
    txtPriceOut.clear();
    imageAsset = ImageModel.instance.obs;
  }

  var loading = false.obs;
  Category? cate;
  var listCategory = <Category>[];
  var txtDesc = TextEditingController();
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
        txtDesc.text = result.desc ?? '';
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

  var border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade200),
    borderRadius: BorderRadius.circular(6),
  );
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        onPopInvoked: (didPop) {
          Get.put(AdminProductController()).fetchProduct();
        },
        child: Scaffold(
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
                      Row(
                        children: [
                          FadeInLeft(
                            from: 10,
                            child: const Text("Description"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        minLines: 2,
                        maxLines: 5,
                        controller: txtDesc,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'describe your product',
                          hintStyle: hintStyle(),
                          border: border,
                          enabledBorder: border,
                          focusedBorder: border,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FadeInLeft(
                            from: 5,
                            child: Obx(() {
                              return CardPhoto(
                                image: imageAsset.value,
                                onClear: () {
                                  imageAsset(ImageModel.instance);
                                },
                                onPhotoPicker: (file) {
                                  imageAsset(ImageModel.uploadImageWeb(file!));
                                },
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
                            router.pop();
                            loadingDialog();
                            await proCon
                                .deleteProduct(pid: widget.pId)
                                .then((value) {
                              if (value) {
                                showTaost(
                                    'Product has been deleted successfully✅');
                                router.pop();
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
                                    desc: txtDesc.text,
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
                                    desc: txtDesc.text,
                                    priceIn: double.parse(priceIn),
                                    priceout: double.parse(priceout),
                                    qty: int.parse(qty),
                                    image: imageAsset.value,
                                    categoryId: cate?.id ?? 0,
                                  );
                                }
                                popLoadingDialog();
                                router.pop();
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
