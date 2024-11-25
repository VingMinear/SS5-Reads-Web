import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/modules/profile/screens/profile_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/ListExtension.dart';
import 'package:homework3/utils/NumExtension.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/SizeDevice.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/break_point.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/utils/logo.dart';

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
    "About",
    "Contact Us",
  ];

  final txtCon = TextEditingController().obs;
  final _keyScaff = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaff,
      backgroundColor: const Color(0xffFBFAF6),
      body: Column(
        children: [
          _navBar(),
          Expanded(child: widget.screen),
        ],
      ),
      endDrawer: LayoutBuilder(builder: (context, _) {
        if (SizeDevice().isWeb()) {
          if (_keyScaff.currentState!.isEndDrawerOpen) {
            _keyScaff.currentState!.closeEndDrawer();
          }
        }
        return Drawer(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              const Logo(),
              Divider(
                color: Colors.grey.shade300,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: listMenu.length,
                  itemBuilder: (context, index) {
                    var item = listMenu[index];
                    return ListTile(
                      onTap: () {
                        _keyScaff.currentState!.closeEndDrawer();
                        _onTapMenu(index);
                      },
                      title: Center(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                color: mainColor,
                alignment: Alignment.center,
                child: const Text(
                  'App Version : 1.0 | Copyright © by SS5',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navBar() {
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
        child: LayoutBuilder(builder: (context, _) {
          return Container(
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
                  visible: SizeDevice().isWeb(),
                  replacement: const Expanded(
                    child: SizedBox.shrink(),
                  ),
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
                            return FadeInLeft(
                              from: 5,
                              child: InkWell(
                                onTap: () {
                                  _onTapMenu(index);
                                },
                                child: Text(
                                  item,
                                ),
                              ),
                            );
                          },
                        ).seperateRow(25),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: StatefulBuilder(builder: (context, state) {
                            return TextField(
                              controller: txtCon.value,
                              autocorrect: true,
                              autofocus: false,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                if (value.removeAllWhitespace
                                    .trim()
                                    .isNotEmpty) {
                                  router.go(
                                    '/list-products?search=$value',
                                  );
                                }
                              },
                              onChanged: (value) {
                                state(() {});
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
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
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (GlobalClass().isUserLogin)
                        IconButton(
                          onPressed: () {
                            router.go('/cart');
                          },
                          icon: cartIcon(Colors.black),
                        ),
                      const SizedBox(width: 10),
                      GlobalClass().isUserLogin
                          ? IconButton(
                              onPressed: () {
                                showFilterOverlay(
                                  offset: const Offset(80, 10),
                                  context: context,
                                  widget: const Profile(),
                                );
                              },
                              icon: const Icon(Icons.person),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                showAlertDialog(
                                  context: context,
                                  content: const LoginScreen(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  color: mainColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.scale, vertical: 10),
                                child: const Text('Login'),
                              ),
                            ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !SizeDevice().isWeb(),
                  child: Row(
                    children: [
                      IconButton(
                        icon: FlipInX(
                          child: SvgPicture.asset(
                            'assets/icons/menubar.svg',
                            width: 35,
                            height: 35,
                          ),
                        ),
                        onPressed: () {
                          _keyScaff.currentState!.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _onTapMenu(int index) {
    switch (index) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/list-products');
        break;
      case 2:
        router.go('/about-us');
        break;
      default:
        router.go('/contact-us');
        break;
    }
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
