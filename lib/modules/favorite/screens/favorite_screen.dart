import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../constants/Color.dart';
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
            appBar: customAppBar(
              title: 'Favorite',
              useLeadingCustom: false,
              showNotification: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: con.loading.value
                      ? AnimationLimiter(
                          child: ListView.separated(
                            itemCount: 4,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    physics: const AlwaysScrollableScrollPhysics(),
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
                                        duration:
                                            const Duration(milliseconds: 600),
                                        child: FadeInAnimation(
                                          duration: const Duration(milliseconds: 600),
                                          child: Slidable(
                                            key: GlobalKey(),
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              extentRatio: 0.3,
                                              children: [
                                                SlidableAction(
                                                  spacing: 5,
                                                  onPressed: (context) {
                                                    var proCon = Get.put(
                                                        ProductController());
                                                    con.listFav.removeAt(index);
                                                    proCon
                                                        .updFavorite(
                                                      proId: product.productId!,
                                                      isFav: true,
                                                    )
                                                        .then((value) {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Favorites has been removed",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0.59),
                                                        textColor: whiteColor,
                                                        fontSize: 15.0,
                                                      );
                                                    });
                                                    setState(() {});
                                                  },
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )
                                              ],
                                            ),
                                            child: Container(
                                              child: CardFavorite(
                                                product: product,
                                              ),
                                            ),
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
          );
        });
  }
}
