import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homework3/model/report_model.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../../utils/colors.dart';

class CustomTransactionCard extends StatelessWidget {
  final ReportModel eachItem;
  const CustomTransactionCard({
    super.key,
    required this.eachItem,
  });

  @override
  Widget build(BuildContext context) {
    var shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );

    return Material(
      color: Colors.white,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: () {},
        child: eachCard(),
      ),
    );
  }

  Widget eachText(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: (14),
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontSize: (14),
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  ListTile eachCard() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: SvgPicture.asset(
        "assets/icons/money.svg",
        width: 30,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eachItem.customerName,
            style: const TextStyle(
              fontSize: (16),
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            eachItem.paymentType,
            style: const TextStyle(
              fontSize: (14),
              color: Colors.grey,
            ),
          )
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: AppColor.successColor,
                fontSize: 15,
              ),
              children: [
                const TextSpan(
                  text: "+",
                ),
                const TextSpan(
                  text: "\$",
                ),
                TextSpan(
                  text: eachItem.amountSale.formatCurrency,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            eachItem.date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
