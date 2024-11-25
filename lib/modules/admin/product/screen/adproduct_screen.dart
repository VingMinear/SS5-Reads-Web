import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/category.dart';
import 'package:homework3/modules/admin/order/screens/admin_order_screen.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_detail.dart';
import 'package:homework3/modules/home_screen/components/mainbody.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/CustomButton.dart';

import '../../../../widgets/CustomNoContent.dart';
import '../../../../widgets/product_card.dart';
import '../controller/adproduct_con.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({
    super.key,
  });

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  late final PageController pageController;

  int pageNum = 0;

  var loading = true.obs;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await categoryCon.fetchCategory();
      await con.fetchProduct();
    });
    super.initState();
  }

  var gredient = const LinearGradient(
    colors: [
      Color(0xff4AB8F3),
      Color(0xff9ADFF5),
    ],
    end: Alignment.topCenter,
    begin: Alignment.bottomRight,
  );
  var categoryCon = Get.put(CategoryController());
  var con = Get.put(AdminProductController());
  var debouce = Debouncer(delay: const Duration(milliseconds: 300));
  var divider = const Expanded(
      child: Divider(
    color: mainColor,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetX<AdminProductController>(
        init: AdminProductController(),
        builder: (conPro) {
          return RefreshIndicator(
            onRefresh: () async {
              dismissKeyboard(context);

              con.txtSearch.clear();
              con.fetchProduct();
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
                        "Products",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DefaultTabController(
                          length: con.listCategory.length,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 8.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: TabBar(
                              isScrollable: true,
                              labelPadding: EdgeInsets.zero,
                              indicatorColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                              tabAlignment: TabAlignment.start,
                              onTap: (index) async {
                                conPro.selectCateIndex = index;
                                await con.fetchProduct();
                              },
                              overlayColor: const WidgetStatePropertyAll(
                                  Colors.transparent),
                              tabs: List.generate(
                                con.listCategory.length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: buildTabBar(
                                      title: con.listCategory[index].title,
                                      isSelected: con.selectCateIndex == index,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SearchBarWidget(
                            controller: con.txtSearch,
                            onChanged: (p0) {
                              debouce.call(() {
                                con.fetchProduct();
                              });
                            },
                          ),
                        ),
                      ),
                      CustomButton(
                        onPress: () {
                          showAlertDialog(
                            content: const AdminProductDetail(
                              isEdit: false,
                              pId: 0,
                            ),
                          );
                        },
                        title: 'Create',
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: con.allProducts.isEmpty
                      ? const CustomNoContent(
                          title: 'No product found',
                          isScroll: true,
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  conPro.loading.value
                                      ? buildShimmerGrid()
                                      : LayoutBuilder(
                                          builder: (context, box) {
                                            var sliverDelegate =
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  gridCount(box.maxWidth),
                                              mainAxisExtent: 250,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20,
                                            );
                                            return GridView.builder(
                                              itemCount:
                                                  conPro.allProducts.length,
                                              gridDelegate: sliverDelegate,
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.only(
                                                  bottom: 20),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var data =
                                                    conPro.allProducts[index];
                                                return ProductCard(
                                                  data: data,
                                                  isAdmin: true,
                                                  ontap: (data) {
                                                    showAlertDialog(
                                                      content:
                                                          AdminProductDetail(
                                                        isEdit: true,
                                                        pId:
                                                            data.productId ?? 0,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    this.onChanged,
    this.controller,
  });
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintText: "${'Searching'}...",
        suffixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
