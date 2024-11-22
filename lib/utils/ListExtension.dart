import 'package:flutter/widgets.dart';

extension AddSeperate on List<Widget> {
  List<Widget> gap(double height) {
    List<Widget> separatedList = [];
    for (int i = 0; i < length; i++) {
      if (i == length - 1) {
        separatedList.add(Container(
          margin: EdgeInsets.only(
            top: height,
            bottom: height,
          ),
          child: this[i],
        ));
        continue;
      }
      separatedList.add(Container(
        margin: EdgeInsets.only(top: height),
        child: this[i],
      ));
    }
    return separatedList;
  }

  List<Widget> seperate(double height) {
    List<Widget> separatedList = [];
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        separatedList.add(Container(
          child: this[i],
        ));
        continue;
      } else if (i == length - 1) {
        separatedList.add(Container(
          margin: EdgeInsets.only(
            top: height,
          ),
          child: this[i],
        ));
        continue;
      }
      separatedList.add(Container(
        margin: EdgeInsets.only(top: height),
        child: this[i],
      ));
    }
    return separatedList;
  }

  List<Widget> seperateRow(double width) {
    List<Widget> separatedList = [];
    for (int i = 0; i < length; i++) {
      if (i == 0) {
        separatedList.add(Container(
          child: this[i],
        ));
        continue;
      } else if (i == length - 1) {
        separatedList.add(Container(
          margin: EdgeInsets.only(
            left: width,
          ),
          child: this[i],
        ));
        continue;
      }
      separatedList.add(Container(
        margin: EdgeInsets.only(left: width),
        child: this[i],
      ));
    }
    return separatedList;
  }

  List<Widget> gapRow(double width) {
    List<Widget> separatedList = [];
    for (int i = 0; i < length; i++) {
      if (i == length - 1) {
        separatedList.add(Container(
          margin: EdgeInsets.only(left: width, right: width),
          child: this[i],
        ));
        continue;
      }
      separatedList.add(Container(
        margin: EdgeInsets.only(left: width),
        child: this[i],
      ));
    }
    return separatedList;
  }
}
