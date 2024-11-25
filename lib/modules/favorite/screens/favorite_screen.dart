import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/colors.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/EmptyProduct.dart';
import '../../../widgets/list_card_shimmer.dart';
import '../../home_screen/controller/product_controller.dart';
import '../components/card_favorite.dart';
import '../controller/favorite_controller.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  var controller;
  @override
  void initState() {
    setState(() {
      controller = TabController(length: 4, vsync: this);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteController>(
        init: FavoriteController(),
        builder: (con) {
          return Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'My favorites :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      height: 25,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: con.loading.value
                          ? AnimationLimiter(
                              child: ListView.separated(
                                itemCount: 4,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                          : AnimationLimiter(
                              child: con.listFav.isEmpty
                                  ? const EmptyProduct(
                                      desc: "No Product Favorite found.",
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () async {
                                        await con.getProductFavorite();
                                      },
                                      child: ListView.separated(
                                        itemCount: con.listFav.length,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 15,
                                          right: 15,
                                        ),
                                        itemBuilder: (context, index) {
                                          var product = con.listFav[index];
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 600),
                                            child: FadeInAnimation(
                                              duration: const Duration(
                                                  milliseconds: 600),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: CardFavorite(
                                                      product: product,
                                                      showShadow: true,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  MaterialButton(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8,
                                                      ),
                                                    ),
                                                    color: AppColor.errorColor,
                                                    onPressed: () {
                                                      var proCon = Get.put(
                                                          ProductController());
                                                      con.listFav
                                                          .removeAt(index);
                                                      proCon
                                                          .updFavorite(
                                                        proId:
                                                            product.productId!,
                                                        isFav: true,
                                                      )
                                                          .then((value) {
                                                        showTaost(
                                                          "Favorites has been removed",
                                                          type:
                                                              ToastificationType
                                                                  .error,
                                                        );
                                                      });
                                                      setState(() {});
                                                    },
                                                    child: const Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 20),
                                      ),
                                    ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
