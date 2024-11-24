import 'package:flutter/material.dart';
import 'package:homework3/modules/admin/dashboard/components/bar_graph_card.dart';

import 'package:homework3/modules/admin/dashboard/components/line_chart_card.dart';
import 'package:homework3/utils/colors.dart';
import 'package:homework3/utils/responsive.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Container(
        color: AppColor.bgScaffold,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 15 : 18),
          child: Column(
            children: [
              height(context),
              LineChartCard(),
              height(context),
              BarGraphCard(),
              height(context),
            ],
          ),
        )));
  }
}
