import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/admin/report/components/card_report.dart';
import 'package:homework3/modules/admin/report/controller/report_controller.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/style.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../../constants/Color.dart';
import '../../../../utils/colors.dart';

class Report extends StatefulWidget {
  const Report({super.key, required this.totalOrder});
  final int totalOrder;
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  get shadow => BoxShadow(
        color: AppColor.shadowColor,
        offset: const Offset(2, 2),
        blurRadius: 0.5,
      );
  ReportController con = Get.put(ReportController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      con.onRefresh();
    });
    super.initState();
  }

  Future fetchData() async {
    await con.fetchReportList();
  }

  int touchedIndex = -1;
  var user = GlobalClass().user.value;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: customAppBar(title: "Report"),
        backgroundColor: AppColor.bgScaffold,
        body: con.loading.value
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: mainColor,
                ),
              )
            : Column(
                children: [
                  Offstage(
                    offstage: false,
                    child: Container(
                      decoration: cardBoxDecoration(
                        raduis: 20,
                        boxShadow: AppColor.boxShadow,
                      ),
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.7,
                              child: Image.asset(
                                "assets/images/report.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 230,
                            child: Echarts(
                              option: '''
                      {
                    tooltip: {
                      trigger: 'item'
                    },
                    legend: {
                      top: '0%',
                      left: 'center'
                    },
                    series: [
                      {
                        name: 'Reports',
                        type: 'pie',
                        radius: ['40%', '60%'],
                        avoidLabelOverlap: false,
                        label: {
                          show: false,
                          position: 'center'
                        },
                        emphasis: {
                          label: {
                    show: true,
                    fontSize: 15,
                    fontWeight: 'bold'
                          }
                        },
                        labelLine: {
                          show: false
                        },
                        data: [
                          { value: ${con.totalUser}, name: 'Users' },
                          { value: ${con.stock}, name: 'Stock Products' },
                         { value: ${widget.totalOrder},name: 'Orders' }
                        ]
                      }
                    ]
                        }
                    ''',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        "All Reports",
                        style: AppText.txt16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        con.onRefresh();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff4AB8F3),
                              Color(0xff9ADFF5),
                            ],
                            begin: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 15, top: 15, right: 15, bottom: 10),
                          itemBuilder: (context, index) {
                            var data = con.listReport[index];
                            return CustomTransactionCard(eachItem: data);
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: con.listReport.length,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
