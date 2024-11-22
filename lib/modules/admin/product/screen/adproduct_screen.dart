import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/category.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_detail.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/CustomNoContent.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/grid_card_shimmer.dart';
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

  var loading = false.obs;
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
      appBar: customAppBar(title: 'Product', backgroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() {
            return const AdminProductDetail(
              isEdit: false,
              pId: 0,
            );
          })!
              .then((value) async => await con.fetchProduct());
        },
        heroTag: "",
        elevation: 1,
        tooltip: "Add Product",
        backgroundColor: Colors.black.withOpacity(0.45),
        shape: CircleBorder(side: BorderSide(color: AppColor.whiteColor)),
        child: SvgPicture.asset(
          'assets/icons/ic_add.svg',
          width: 20,
        ),
      ),
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
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: AppColor.boxShadow,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      )),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
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
                      const SizedBox(
                        height: 10,
                      ),
                      buildCategory(),
                      const SizedBox(
                        height: 10,
                      ),
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
                                      : GridView.builder(
                                          itemCount: conPro.allProducts.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            mainAxisExtent: 265,
                                          ),
                                          shrinkWrap: true,
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data =
                                                conPro.allProducts[index];
                                            return ProductCard(
                                              data: data,
                                              isAdmin: true,
                                              ontap: (data) {
                                                Get.to(() {
                                                  return AdminProductDetail(
                                                    isEdit: true,
                                                    pId: data.productId ?? 0,
                                                  );
                                                })!
                                                    .then(
                                                  (value) async =>
                                                      await con.fetchProduct(),
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

  Widget buildCategory() {
    var conPro = Get.put(AdminProductController());
    return Obx(
      () => loading.value
          ? SizedBox(
              height: 40,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                itemCount: 6,
              ),
            )
          : DefaultTabController(
              length: conPro.listCategory.length,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  splashBorderRadius: BorderRadius.circular(12),
                  onTap: (index) async {
                    conPro.selectCateIndex = index;
                    await con.fetchProduct();
                  },
                  labelPadding: const EdgeInsets.symmetric(horizontal: 25),
                  tabs: conPro.listCategory.map((e) {
                    return Tab(
                      child: Text(
                        e.title,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 265,
      ),
      itemBuilder: (context, index) {
        return const GridShimmer(
          isAdmin: true,
        );
      },
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
