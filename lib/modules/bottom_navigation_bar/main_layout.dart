import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/modules/bottom_navigation_bar/bottom_controller.dart';
import 'package:homework3/modules/profile/screens/profile_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/ListExtension.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/utils/logo.dart';
import 'package:homework3/widgets/google_map.dart';

import '../../widgets/custom_overlay.dart';
import '../cart/controllers/cart_controller.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.screen});
  final Widget screen;
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  var listMenu = [
    "Home",
    "Shop",
    "About Us",
    "Contact Us",
  ];

  final txtCon = TextEditingController().obs;
  @override
  Widget build(BuildContext context) {
    Get.put(MapController()).customMarkerIcon();
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        // Get.put(MapController()).currentLocaton();
      },
    );
    var con = Get.put(BottomController());

    return Scaffold(
      backgroundColor: const Color(0xffFBFAF6),
      body: Column(
        children: [
          Builder(builder: (ctx) {
            return Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowColor,
                      offset: const Offset(0, 2),
                      blurRadius: 0.5,
                    )
                  ],
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: BreakPoint.lg),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => router.go('/home'),
                        child: const Row(
                          children: [
                            Logo(
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'SS5 Reads',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: MediaQuery.of(ctx).size.width > 600,
                        child: Expanded(
                          flex: 2,
                          child: DefaultTextStyle(
                            style: const TextStyle(fontSize: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                listMenu.length,
                                (index) {
                                  var item = listMenu[index];
                                  return InkWell(
                                    onTap: () {
                                      switch (index) {
                                        case 0:
                                          router.go('/home');
                                          break;
                                        case 1:
                                          router.go('/list-products');
                                          break;
                                        case 2:
                                          break;
                                        default:
                                          break;
                                      }
                                    },
                                    child: Text(
                                      item,
                                    ),
                                  );
                                },
                              ).seperateRow(25),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: MediaQuery.of(ctx).size.width > 600,
                        child: Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: StatefulBuilder(
                                      builder: (context, state) {
                                    return TextField(
                                      controller: txtCon.value,
                                      autocorrect: true,
                                      autofocus: true,
                                      textInputAction: TextInputAction.search,
                                      onSubmitted: (value) {
                                        if (value.removeAllWhitespace
                                            .trim()
                                            .isNotEmpty) {
                                          router.go(
                                              '/list-products?search=$value');
                                        }
                                      },
                                      onChanged: (value) {
                                        state(() {});
                                      },
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey[200],
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        hintText: "Search...",
                                        prefixIcon: const IconButton(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        suffixIcon: txtCon.value.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  txtCon.value.clear();
                                                  setState(() {});
                                                },
                                              )
                                            : null,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  router.go('/cart');
                                },
                                icon: cartIcon(Colors.black),
                              ),
                              Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    if (GlobalClass().isUserLogin) {
                                      showFilterOverlay(
                                        offset: const Offset(80, 10),
                                        context: context,
                                        widget: const Profile(),
                                      );
                                    } else {
                                      showAlertDialog(
                                        context: context,
                                        content: const LoginScreen(),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.person),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Expanded(child: widget.screen),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

cartIcon(Color iconColor) {
  return Obx(() {
    var cartController = Get.put(CartController());
    var lenghtBadge = cartController.shoppingCart.length;
    var badgeCount = lenghtBadge > 9 ? '9+' : lenghtBadge.toString();
    return badges.Badge(
      showBadge: lenghtBadge != 0 ? true : false,
      ignorePointer: false,
      position: BadgePosition.topEnd(
        top: -5,
        end: -5,
      ),
      badgeContent: Text(
        badgeCount,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
        ),
      ),
      badgeAnimation: const badges.BadgeAnimation.slide(
        slideTransitionPositionTween:
            SlideTween(begin: Offset(-0.05, 0.1), end: Offset(0.0, 0.0)),
        animationDuration: Duration(seconds: 1),
        colorChangeAnimationDuration: Duration(seconds: 1),
        loopAnimation: false,
        curve: Curves.fastOutSlowIn,
        colorChangeAnimationCurve: Curves.easeInCubic,
      ),
      badgeStyle: badges.BadgeStyle(
        shape: badges.BadgeShape.circle,
        badgeColor: Colors.red,
        padding: EdgeInsets.all(badgeCount.length >= 2 ? 5 : 6.5),
        borderRadius: BorderRadius.circular(4),
        elevation: 0,
      ),
      child: Icon(
        CupertinoIcons.cart,
        color: iconColor,
      ),
    );
  });
}
