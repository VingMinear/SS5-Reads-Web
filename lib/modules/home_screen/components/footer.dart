import 'package:bootstrap_grid/bootstrap_grid.dart';
import 'package:flutter/material.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/utils/ListExtension.dart';
import 'package:homework3/utils/break_point.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static final listSocail = [
    "images/facebook.png",
    "images/linkedin-logo.png",
    "images/telegram.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: mainColor,
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: BreakPoint.md),
              padding: const EdgeInsets.all(10),
              child: BootstrapRow(
                runSpacing: 15,
                children: [
                  const BootstrapCol(
                    xs: 12,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "No. T01, National Road 2, Sangkat Chak Angrae Leu,Khan Mean Chey, Phnom Penh 120601, Cambodia.",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const BootstrapCol(
                    xs: 12,
                    md: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "SS5@gmail.com",
                        ),
                      ],
                    ),
                  ),
                  BootstrapCol(
                    xs: 12,
                    md: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Follow Us:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: List.generate(
                            listSocail.length,
                            (index) {
                              return Image.asset(
                                width: 20,
                                height: 20,
                                listSocail[index],
                                color: Colors.white,
                              );
                            },
                          ).seperateRow(10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'App Version : 1.0 | Copyright © by SS5',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
