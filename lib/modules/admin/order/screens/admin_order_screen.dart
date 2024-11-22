import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/admin/order/components/build_list_card.dart';
import 'package:homework3/widgets/CustomNoContent.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import '../controller/adorder_controller.dart';
import 'order_detail.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      con.fetchOrder();
    });
    super.initState();
  }

  var con = Get.put(AdOrderController());
  @override
  Widget build(BuildContext context) {
    var debounce = Debouncer(delay: const Duration(milliseconds: 200));
    var scrollCon = ScrollController();
    return Scaffold(
      appBar: customAppBar(
        title: 'Order',
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            DefaultTabController(
              length: con.lsTabOrder.length,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 8.0),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TabBar(
                  isScrollable: true,
                  labelPadding: EdgeInsets.zero,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  onTap: (index) async {
                    con.selected(index);
                    con.loading(true);
                    if (scrollCon.hasClients) {
                      scrollCon.jumpTo(0);
                    }
                    debounce.call(() async {
                      await con.onRefresh();
                    });
                  },
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  tabs: List.generate(
                    con.lsTabOrder.length,
                    (index) {
                      return Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: buildTabBar(
                            title: con.lsTabOrder[index].title,
                            isSelected: con.selected.value == index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Obx(() {
              return Expanded(
                child: con.loading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: mainColor,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          con.onRefresh();
                        },
                        child: con.isEmptyOrder.value
                            ? const CustomNoContent(
                                isScroll: true,
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: con.listOrders.length,
                                controller: scrollCon,
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15)
                                    .copyWith(bottom: 0),
                                itemBuilder: (context, index) {
                                  var item = con.listOrders[index];
                                  return buildListCard(
                                    item: item,
                                    con: con,
                                    onTap: () {
                                      Get.to(OrderDetail(
                                        data: item,
                                      ))!
                                          .then((value) async {
                                        await con.onRefresh();
                                      });
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 15);
                                },
                              ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar({
    required String title,
    required bool isSelected,
    void Function()? onPressed,
    bool ignorePointer = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.5, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isSelected ? null : AppColor.greyBtn,
        gradient: isSelected ? gradientBtn : null,
      ),
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        return Text(
          title,
          style: AppText.txt15.copyWith(
            color: AppColor.whiteColor,
          ),
        );
      }),
    );
  }
}
