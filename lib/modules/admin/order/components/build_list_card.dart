import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/Enum.dart';
import '../../../../utils/Utilty.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import '../controller/adorder_controller.dart';

Widget buildListCard({
  void Function()? onTap,
  required AdminOrderModel item,
  required AdOrderController con,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.grey,
      ),
      width: double.infinity,
      child: Builder(builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: item.colorStatus.withOpacity(0.6),
              child: SvgPicture.asset(
                'assets/icons/order/ic_order.svg',
                width: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.orderCode,
                              style: AppText.txt14.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Name : ${item.receiverName}',
                              style: AppText.txt14,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      status(
                        orderStatus: item.status,
                        statusColor: item.colorStatus,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.date,
                              style: AppText.txt11,
                            ),
                          ],
                        ),
                      ),
                      amount(item: item, con: con),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ),
  );
}

Widget status({
  required OrderStatus orderStatus,
  required Color statusColor,
}) {
  var txtColor = AppColor.whiteColor;

  return Builder(builder: (context) {
    return Container(
      padding: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        orderStatus.name.capitalize(),
        style: AppText.txt13.copyWith(
          color: txtColor,
        ),
      ),
    );
  });
}

Widget amount({
  required AdminOrderModel item,
  required AdOrderController con,
}) {
  var amount = (item.totalAmount);

  return Builder(builder: (context) {
    if (item.status == OrderStatus.pending) {
      return MaterialButton(
        padding: const EdgeInsets.all(5).copyWith(left: 10, right: 10),
        onPressed: () async {
          con.loading(true);
          await con
              .updateOrder(status: con.lsTabOrder[1], ordID: item.orderId)
              .then((value) async {
            if (value) {
              showTaost('Order has been accepted');
            }
            await con.onRefresh();
          });

          con.loading(false);
        },
        color: AppColor.successColor,
        minWidth: 0,
        elevation: 1,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        highlightElevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7),
          child: DefaultTextStyle(
            style: AppText.txt14.copyWith(color: AppColor.whiteColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$amount',
                ),
                const Text(' | '),
                const Text(
                  'accept',
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text(
        '\$$amount',
        style: AppText.txt15.copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  });
}
