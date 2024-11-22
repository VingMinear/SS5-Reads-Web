import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/home_screen/components/footer.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/StripeHandler.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/EmptyProduct.dart';
import 'package:homework3/widgets/grid_card_shimmer.dart';
import 'package:homework3/widgets/product_card.dart';

import '../../../model/category.dart';
import '../../../widgets/bannerslide.dart';
import '../../../widgets/midletext.dart';
import '../controller/home_controller.dart';
import '../controller/product_controller.dart';

class MainBody extends StatefulWidget {
  const MainBody({
    super.key,
  });

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  late final PageController pageController;

  int pageNum = 0;
  var con = Get.put(HomeController());
  var conPro = Get.put(ProductController());
  var categoryCon = Get.put(CategoryController());
  var loadingCategory = true.obs;
  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      //viewportFraction: 0.92,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getCategory();
      await conPro.getRecommentProducts();
    });
    super.initState();
  }

  Future<void> _getCategory() async {
    loadingCategory(true);
    await categoryCon.fetchCategory();
    loadingCategory(false);
  }

  var keyScaff = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScaff,
      endDrawer: const Drawer(),
      backgroundColor: const Color.fromARGB(161, 255, 255, 255),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          StripeService.makePayment();
        },
        child: const Icon(
          Icons.apple,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await conPro.getRecommentProducts();
          await _getCategory();
          setState(() {});
        },
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          MyBanner(
                            banner: con.slidesBanner,
                          ),
                          Center(
                            child: Container(
                              constraints:
                                  const BoxConstraints(maxWidth: BreakPoint.lg),
                              margin: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Categories",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: mainColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // menu icons
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: categoryCon.homeCategries.length,
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 130,
                                      mainAxisSpacing: 24,
                                      crossAxisSpacing: 24,
                                      crossAxisCount: 4,
                                    ),
                                    itemBuilder: ((context, index) {
                                      final data =
                                          categoryCon.homeCategries[index];

                                      return InkWell(
                                        onTap: () {
                                          router.go(
                                              '/list-products?categoryId=${data.id}');
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            boxShadow: shadow,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: CustomCachedNetworkImage(
                                                  imgUrl: data.icon.image.value,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              FittedBox(
                                                child: Text(
                                                  data.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const MidleText(),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  conPro.loadingNewCollection.value
                                      ? buildShimmerGrid()
                                      : conPro.listRecommentProduct.isEmpty
                                          ? const Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 40),
                                                child: EmptyProduct(
                                                    desc: 'No product found'),
                                              ),
                                            )
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
                                              return AnimationLimiter(
                                                child: GridView.builder(
                                                  itemCount: conPro
                                                      .listRecommentProduct
                                                      .length,
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  gridDelegate: sliverDelegate,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var data = conPro
                                                            .listRecommentProduct[
                                                        index];
                                                    return AnimationConfiguration
                                                        .staggeredList(
                                                      position: index,
                                                      duration: const Duration(
                                                          milliseconds: 375),
                                                      child: FadeInAnimation(
                                                        child: ProductCard(
                                                          isAdmin: false,
                                                          data: data,
                                                          ontap: (data) {
                                                            router.go(
                                                              '/product-detail?pId=${data.productId}&cateId=${data.categoryId}',
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Footer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildShimmerGrid() {
  return LayoutBuilder(builder: (context, box) {
    var sliverDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: gridCount(box.maxWidth),
      mainAxisExtent: 250,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    );
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: sliverDelegate,
      itemBuilder: (context, index) {
        return const GridShimmer(
          isAdmin: false,
        );
      },
    );
  });
}
