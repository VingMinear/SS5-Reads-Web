import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/Menu.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/utils/logo.dart';

class MenuSide extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MenuSide({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State createState() => _MenuSideState();
}

class _MenuSideState extends State<MenuSide> {
  List<MenuItem> get listMenu => <MenuItem>[
        MenuItem(
          title: 'Dashboard',
          isSelected: currentRoute == '/admin',
          icon: const Icon(
            Icons.dashboard,
            color: mainColor,
          ),
        ),
        MenuItem(
          title: 'Order',
          isSelected: currentRoute.contains('admin/order'),
          icon: _svgIcon('assets/icons/home/ic_order.svg'),
        ),
        MenuItem(
          title: 'Product',
          isSelected: currentRoute.contains('admin/product'),
          icon: _svgIcon('assets/icons/home/ic_cart.svg'),
        ),
        MenuItem(
          title: 'User',
          isSelected: currentRoute.contains('admin/user'),
          icon: _svgIcon('assets/icons/ic_user.svg'),
        ),
        MenuItem(
          title: 'Cateogry',
          isSelected: currentRoute.contains('admin/category'),
          icon: _svgIcon(
            'assets/icons/home/category.svg',
          ),
        ),
        MenuItem(
          title: 'SlideShow',
          isSelected: currentRoute.contains('admin/slideshow'),
          icon: const Icon(
            CupertinoIcons.slider_horizontal_below_rectangle,
            color: mainColor,
            size: 20,
          ),
        ),
      ];

  static Widget _svgIcon(String path) {
    return SizedBox(
      width: 25,
      height: 25,
      child: SvgPicture.asset(
        path,
        color: mainColor,
      ),
    );
  }

  static String get currentRoute =>
      router.routerDelegate.currentConfiguration.uri.toString().toLowerCase();
  @override
  Widget build(BuildContext context) {
    log(currentRoute);
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppColor.boxShadow,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0).copyWith(top: 5),
        child: Column(
          children: [
            const Logo(),
            Expanded(
              child: Builder(builder: (context) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var item = listMenu[index];

                    return Tooltip(
                      message: item.title,
                      child: InkWell(
                        mouseCursor: SystemMouseCursors.click,
                        onTap: () {
                          switch (index) {
                            case 0:
                              router.go('/admin');
                              break;
                            case 1:
                              router.go('/admin/order');
                              break;
                            case 2:
                              router.go('/admin/product');
                              break;
                            case 3:
                              router.go('/admin/user');
                              break;
                            case 4:
                              router.go('/admin/category');
                              break;
                            default:
                              router.go('/admin/slideshow');
                              break;
                          }
                        },
                        child: card(
                          isSelected: item.isSelected,
                          item: item,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: listMenu.length,
                );
              }),
            ),
            InkWell(
              onTap: () {
                alertDialogConfirmation(
                  title: "Logout",
                  desc: "Are you sure you want to Logout ?",
                  onConfirm: () {
                    router.pop();
                    logOut();
                  },
                );
              },
              child: card(
                isSelected: true,
                item: MenuItem(
                  icon: Image.asset(
                    'assets/icons/profile/logout@2x.png',
                    width: 25,
                    height: 25,
                  ),
                  isSelected: true,
                  title: "Log Out",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget card({required bool isSelected, required MenuItem item}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(left: BorderSide(color: mainColor, width: 2))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.center,
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: item.icon,
          ),
          const SizedBox(width: 10),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
