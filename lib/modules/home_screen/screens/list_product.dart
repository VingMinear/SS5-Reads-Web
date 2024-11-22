import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/home_screen/controller/product_controller.dart';
import 'package:homework3/widgets/EmptyProduct.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/list_card_shimmer.dart';

import '../../bottom_navigation_bar/main_layout.dart';
import '../../cart/screens/cart_screen.dart';
import '../components/card_list.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({
    super.key,
    this.categoryId,
    this.searchText,
  });

  final int? categoryId;
  final String? searchText;
  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  final loading = false.obs;
  List<ProductModel> listProducts = [];
  final con = Get.put(ProductController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProducts();
    });
    super.initState();
  }

  Future<void> getProducts() async {
    try {
      loading(true);
      if (widget.categoryId != null) {
        await con
            .getProductByCategory(categoryId: widget.categoryId!)
            .then((value) {
          listProducts = value;
        });
      } else if (widget.searchText != null) {
        await con
            .getProductBySearch(productName: widget.searchText!)
            .then((value) {
          listProducts = value;
        });
      } else {
        await con.getAllProducts().then((value) {
          listProducts = value;
        });
      }
    } catch (error) {
      debugPrint(
        'CatchError when getProducts this is error : >> $error',
      );
    }
    loading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // appBar: widget.searchText != null
        //     ? txtFiedl()
        //     : customAppBar(
        //         title: widget.title,
        //         showNotification: false,
        //         action: GestureDetector(
        //           onTap: () {
        //             Get.to(const CartScreen(
        //               back: true,
        //             ));
        //           },
        //           child: cartIcon(
        //             Colors.black54,
        //           ),
        //         ),
        //         spaceLeft: 15,
        //       ),
        body: loading.value
            ? AnimationLimiter(
                child: ListView.separated(
                  itemCount: 4,
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 15, right: 15),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 600),
                    child: const FadeInAnimation(
                      duration: Duration(milliseconds: 200),
                      child: SizedBox(
                        child: ListShimmer(
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: AnimationLimiter(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await getProducts();
                        },
                        child: listProducts.isEmpty
                            ? const EmptyProduct(
                                desc: 'No product found in stocks')
                            : LayoutBuilder(builder: (context, box) {
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gridCount(box.maxWidth),
                                    mainAxisExtent: 140,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: listProducts.length,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  itemBuilder: (context, index) =>
                                      AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 600),
                                    child: FadeInAnimation(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: CardListProduct(
                                          product: listProducts[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // separatorBuilder: (context, index) =>
                                  //     const SizedBox(height: 20),
                                );
                              }),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  int gridCount(double width) {
    if (width <= 600) {
      return 1;
    } else if (width <= 880) {
      return 2;
    } else {
      return 3;
    }
  }

  AppBar txtFiedl() {
    return AppBar(
      leadingWidth: 50,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          color: Colors.black,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(const CartScreen(
              back: true,
            ));
          },
          child: cartIcon(
            Colors.black54,
          ),
        ),
        const SizedBox(width: 16),
      ],
      title: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 10),
          child: TextField(
            readOnly: true,
            enabled: false,
            controller: TextEditingController(text: widget.searchText),
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              hintText: "Search...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
