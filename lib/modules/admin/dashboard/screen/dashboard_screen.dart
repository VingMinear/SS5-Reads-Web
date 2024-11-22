import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/category.dart';
import 'package:homework3/modules/admin/dashboard/controller/dashboard_con.dart';
import 'package:homework3/modules/admin/dashboard/screen/editing_category_screen.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_screen.dart';
import 'package:homework3/modules/admin/slides/screens/slide_screen.dart';
import 'package:homework3/modules/auth/screens/change_pwd.dart';
import 'package:homework3/modules/profile/screens/contact_us.dart';
import 'package:homework3/modules/profile/screens/edit_profile_screen.dart';
import 'package:homework3/modules/profile/screens/profile_screen.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../utils/Date.dart';
import '../../../../utils/Utilty.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import '../../../../widgets/CustomCachedNetworkImage.dart';
import '../../../../widgets/PhotoViewDetail.dart';
import '../../../../widgets/SplashButton.dart';
import '../../order/screens/admin_order_screen.dart';
import '../../user/screen/admin_user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  get shadow => BoxShadow(
        color: AppColor.shadowColor,
        offset: const Offset(2, 2),
        blurRadius: 0.5,
      );
  DashboardCon con = Get.put(DashboardCon());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
      Get.put(CategoryController()).fetchCategory();
    });
    super.initState();
  }

  Future fetchData() async {
    await con.fetchDataHome();
  }

  static _profileIcon(String last) => 'assets/icons/profile/$last';
  List<ProfileOption> get datas => <ProfileOption>[
        ProfileOption.arrow(
            title: 'Profile', icon: _profileIcon('profile@2x.png')),
        ProfileOption.arrow(title: 'Order', icon: _profileIcon('order.png')),
        ProfileOption.arrow(
            title: 'Change Password', icon: _profileIcon('lock@2x.png')),
        ProfileOption.arrow(
            title: 'Contact Us', icon: _profileIcon('user@2x.png')),
        ProfileOption(
          title: 'Logout',
          icon: _profileIcon('logout@2x.png'),
          titleColor: const Color(0xFFF75555),
        ),
      ];

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var listMenu = <Map>[
      {
        'title': 'Order',
        'icon': 'assets/icons/home/ic_order.svg',
      },
      {
        'title': 'Product',
        'icon': 'assets/icons/home/ic_cart.svg',
      },
      {
        'title': 'User',
        'icon': 'assets/icons/ic_user.svg',
      },
      {
        'title': 'Category',
        'icon': 'assets/icons/home/category.svg',
      },
    ];

    var today = DateTime.now();

    var last7Days = today.subtract(const Duration(days: 7));
    var dateDisplay =
        "${Date.month(last7Days)} ${Date.day(last7Days)} - ${DateFormat('MMM d, yyyy').format(today)}";

    var edgeOffset = Get.context!.mediaQueryViewPadding.top;

    double paddingScreen() {
      return 10;
    }

    var keyScaff = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: keyScaff,
      drawer: _drawer(),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/home/menu.png',
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          onPressed: () {
            keyScaff.currentState!.openDrawer();
          },
        ),
        title: Text(
          '${'Welcome Back'.tr} 👋🏻',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await con.fetchDataHome();
          },
          displacement: 8,
          edgeOffset: edgeOffset,
          child: SizedBox(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      children: [
                        // header
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff41497A),
                                Color(0xff333B7A),
                              ],
                              end: Alignment.topCenter,
                              begin: Alignment.bottomRight,
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: DefaultTextStyle(
                              style: AppText.txt14.copyWith(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'total value'.tr.toUpperCase(),
                                                style: AppText.txt15.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    ('last 7 days'),
                                                    style:
                                                        AppText.txt11.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    dateDisplay,
                                                    style:
                                                        AppText.txt11.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        DefaultTextStyle(
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: (26),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$${con.totalAmount.toStringAsFixed(2)}',
                                              ),
                                              const Text(
                                                ' / ',
                                              ),
                                              Text(
                                                '${con.totalOrder}',
                                              ),
                                              Text(
                                                ' ${'orders'.tr}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: (15),
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        GridView.builder(
                          itemCount: listMenu.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 120,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          padding: EdgeInsets.all(paddingScreen()),
                          itemBuilder: (context, index) {
                            var item = listMenu[index];
                            return SplashButton(
                              vertical: 0,
                              // color: Colors.transparent,
                              gradient: gredient,
                              boxShadow: const [],
                              onTap: () {
                                Get.to(() {
                                  switch (index) {
                                    case 0:
                                      return const AdminOrderScreen();
                                    case 1:
                                      return const AdminProductScreen();
                                    case 2:
                                      return const AdminUser();
                                    default:
                                      return const EditingCategoryScreen();
                                  }
                                })!
                                    .then((value) async {
                                  await con.fetchDataHome();
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        item['icon'],
                                        color: whiteColor,
                                        width: (30),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        item['title'],
                                        style: AppText.txt15.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: index == 0,
                                    child: Obx(
                                      () => Positioned(
                                        right: 7,
                                        top: 0,
                                        child: badge(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const SlideScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: gredient,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 0,
                                    offset: const Offset(3, 3),
                                    blurRadius: 1,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.slider,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 20),
                                  Flexible(
                                    child: Text(
                                      "Slides Banner",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeIn(
                  child: const Center(
                      child: Text(
                    'App Version : 1.0 | Copyright © by SS5',
                    style: TextStyle(fontSize: 13),
                  )),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer _drawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(10),
                child: Obx(() {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            PhotoViewDetail(
                              imageUrl: GlobalClass().user.value.photo,
                            ),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CustomCachedNetworkImage(
                            imgUrl: GlobalClass().user.value.photo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'Welcome Back'.tr} 👋🏻',
                          ),
                          Text(
                            "${GlobalClass().user.value.name}",
                            style: AppText.txt16.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  var item = datas[index];
                  return ListTile(
                    leading: Image.asset(
                      item.icon,
                      width: 20,
                    ),
                    minLeadingWidth: 20,
                    title: Text(
                      item.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: item.titleColor),
                    ),
                    onTap: () {
                      if (index != 4) Get.back();
                      switch (index) {
                        case 0:
                          Get.to(const EditProfileScreen());
                          break;
                        case 1:
                          Get.to(const AdminOrderScreen());
                          break;
                        case 2:
                          Get.to(const ChangePwdScreen());
                          break;
                        case 3:
                          Get.to(const ContactUsScreen());
                          break;
                        case 4:
                          alertDialogConfirmation(
                            title: "Logout",
                            desc: "Are you sure you want to Logout ?",
                            onConfirm: () {
                              logOut();
                            },
                          );
                          break;
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 0),
                itemCount: datas.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  badge() {
    var badgeCount =
        con.newOrder.value > 99 ? '99+' : con.newOrder.value.toString();
    return badges.Badge(
      showBadge: con.newOrder.value != 0 ? true : false,
      ignorePointer: false,
      position: badges.BadgePosition.topEnd(
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
            badges.SlideTween(begin: Offset(-0.05, 0.1), end: Offset(0.0, 0.0)),
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
    );
  }
}
