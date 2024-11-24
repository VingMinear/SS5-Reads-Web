import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:homework3/widgets/EmptyProduct.dart';

import '../utils/colors.dart';

enum ActionType { edit, view, delete }

class CustomTable extends StatelessWidget {
  const CustomTable({
    super.key,
    required this.headers,
    required this.rows,
    this.onPagi,
    this.onSelectAll,
    this.showCheckboxColumn = false,
    this.showHeaderCheckbox = false,
    this.showPagination = true,
    this.isHasAction = true,
    this.loading = false,
  });

  final bool showPagination, isHasAction, loading;

  final Function(int page)? onPagi;
  final void Function(bool? select)? onSelectAll;
  final bool showCheckboxColumn, showHeaderCheckbox;
  final List<String> headers;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    var allheaders = [...headers];
    if (isHasAction) {
      allheaders.add("Action");
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: StatefulBuilder(builder: (context, reload) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    DataTable2(
                      onSelectAll: onSelectAll,
                      showCheckboxColumn: showCheckboxColumn,
                      showHeadingCheckBox: showHeaderCheckbox,
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      headingRowDecoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          bottom: BorderSide(color: AppColor.borderColor),
                        ),
                      ),
                      columnSpacing: 0,
                      dividerThickness: 0.2,
                      dataTextStyle: TextStyle(
                        fontSize: 13,
                        color: AppColor.txtDarkColor,
                      ),
                      headingRowColor:
                          WidgetStateProperty.all(AppColor.borderColor),
                      columns: allheaders.map((e) {
                        return DataColumn(
                          label: Text(e),
                        );
                      }).toList(),
                      rows: rows,
                    ),
                    Visibility(
                      visible: loading,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 23),
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(10),
                            child: FadeIn(
                                child: const CircularProgressIndicator()),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: rows.isEmpty && !loading,
                      child: const Positioned(
                        child: EmptyProduct(
                          desc: "No record found",
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  static DataCell action({
    final void Function(ActionType)? onSelectAction,
    bool removeCopy = false,
    bool removeDelete = false,
  }) {
    var listAction = [
      'assets/images/pen.png',
      'assets/images/view.png',
      'assets/images/trash.png',
    ];
    if (removeCopy) {
      listAction.removeAt(1);
    }
    if (removeDelete) {
      listAction.removeAt(2);
    }
    return DataCell(
      Row(
        children: List.generate(
          listAction.length,
          (index) {
            return IconButton(
              onPressed: () {
                if (onSelectAction == null) return;
                if (listAction[index].contains("pen")) {
                  onSelectAction(ActionType.edit);
                } else if (listAction[index].contains("view")) {
                  onSelectAction(ActionType.view);
                } else {
                  onSelectAction(ActionType.delete);
                }
              },
              icon: Image.asset(
                listAction[index],
                color: const Color(0xffC1C0CE),
                width: 19,
                height: 19,
              ),
            );
          },
        ),
      ),
    );
  }

  static DataCell text(String text, {Color? color, Function()? onTap}) =>
      DataCell(
        Text(
          text,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color ?? Colors.white70),
        ),
        onTapDown: onTap != null
            ? (details) {
                onTap();
              }
            : null,
      );
}
