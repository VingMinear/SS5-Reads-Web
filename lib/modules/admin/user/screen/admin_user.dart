import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_screen.dart';
import 'package:homework3/modules/admin/user/controller/admin_user_con.dart';
import 'package:homework3/modules/admin/user/screen/edit_admin_user.dart';
import 'package:homework3/modules/auth/screens/register_screen.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/style.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/EmptyProduct.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/custom_appbar.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({super.key});

  @override
  State<AdminUser> createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  get shadow => BoxShadow(
        color: AppColor.shadowColor,
        offset: const Offset(2, 2),
        blurRadius: 0.5,
      );
  var con = Get.put(AdminUserCon());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  Future fetchData() async {
    await con.fetchCustomer();
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Users"),
      backgroundColor: AppColor.bgScaffold,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SearchBarWidget(
                onChanged: (p0) {
                  con.searchUser(text: p0.toString());
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  con.fetchCustomer();
                },
                child: con.loading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: mainColor,
                        ),
                      )
                    : con.listUser.isEmpty
                        ? const EmptyProduct(
                            desc: "No User found",
                          )
                        : AnimationLimiter(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              itemBuilder: (context, index) {
                                var data = con.listUser[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 600),
                                  child: FadeInAnimation(
                                    child: SlideAnimation(
                                      child: StatefulBuilder(
                                          builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(EditAdminUser(
                                              user: data,
                                            ))!
                                                .then((value) {
                                              fetchData();
                                            });
                                          },
                                          child: Card(
                                            elevation: 4,
                                            surfaceTintColor: Colors.white,
                                            shadowColor:
                                                Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  VerticalDivider(
                                                    color: data.isActive
                                                        ? AppColor.successColor
                                                        : Colors.grey,
                                                    width: 0,
                                                    thickness: 6,
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    height: 50,
                                                    child:
                                                        CustomCachedNetworkImage(
                                                      imgUrl:
                                                          data.photo.isNotEmpty
                                                              ? data.photo
                                                              : '',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icons/ic_user.svg',
                                                              width: 15,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              ": ${data.name}",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icons/ic_mail.svg',
                                                              width: 15,
                                                              color: Colors
                                                                  .blueAccent,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              ": ${data.email}",
                                                              style: AppText
                                                                  .txt13
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          13.4),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/icons/ic_ph.svg',
                                                              color: Colors
                                                                  .blueAccent,
                                                              width: 15,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              ": ${data.phone}",
                                                              style: AppText
                                                                  .txt13
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          13.4),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      PopupMenuButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        color: Colors.white,
                                                        surfaceTintColor:
                                                            Colors.transparent,
                                                        position:
                                                            PopupMenuPosition
                                                                .under,
                                                        offset: const Offset(
                                                            -15, -10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        itemBuilder: (context) {
                                                          return List.generate(
                                                              2, (index) {
                                                            return PopupMenuItem(
                                                              onTap: () async {
                                                                await Future
                                                                    .delayed(
                                                                        Duration
                                                                            .zero);
                                                                switch (index) {
                                                                  case 0:
                                                                    Get.to(() {
                                                                      return EditAdminUser(
                                                                          user:
                                                                              data);
                                                                    });
                                                                    break;
                                                                  case 1:
                                                                    alertDialogConfirmation(
                                                                      title:
                                                                          "Information",
                                                                      desc:
                                                                          "Are you sure you want to deleted user ?",
                                                                      onConfirm:
                                                                          () async {
                                                                        Get.back();
                                                                        con.loading(
                                                                            true);
                                                                        await con.removeUser(
                                                                            userID:
                                                                                data.id ?? '');
                                                                        await fetchData();
                                                                      },
                                                                      btnCancelColor:
                                                                          AppColor
                                                                              .errorColor,
                                                                    );
                                                                    break;
                                                                }
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(index ==
                                                                          0
                                                                      ? "Edit"
                                                                      : "Delete"),
                                                                  SvgPicture
                                                                      .asset(
                                                                    index == 0
                                                                        ? "assets/icons/order/ic_pen.svg"
                                                                        : "assets/icons/order/ic_delete.svg",
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          CupertinoIcons
                                                              .ellipsis_vertical,
                                                          color: Colors.black,
                                                          size: 15,
                                                        ),
                                                      ),
                                                      Transform.scale(
                                                        scale: 0.8,
                                                        child: CupertinoSwitch(
                                                          value: data.isActive,
                                                          onChanged:
                                                              (value) async {
                                                            data.isActive =
                                                                value;
                                                            state(() {});
                                                            loadingDialog();
                                                            await con
                                                                .enableUser(
                                                              user: data,
                                                              enable:
                                                                  data.isActive,
                                                            );
                                                            popLoadingDialog();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount: con.listUser.length,
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const RegisterScreen(
            isAdmin: true,
          ))!
              .then((value) {
            fetchData();
          });
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
    );
  }
}
