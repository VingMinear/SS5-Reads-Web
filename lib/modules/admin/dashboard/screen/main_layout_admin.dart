import 'package:flutter/material.dart';
import 'package:homework3/modules/admin/dashboard/components/menu_side.dart';
import 'package:homework3/utils/responsive.dart';

final GlobalKey<ScaffoldState> adminScaffoldKey = GlobalKey<ScaffoldState>();

class MainLayoutAdmin extends StatelessWidget {
  const MainLayoutAdmin({super.key, required this.screen});
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: adminScaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(width: 250, child: MenuSide(scaffoldKey: adminScaffoldKey))
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context))
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: MenuSide(
                  scaffoldKey: adminScaffoldKey,
                ),
              ),
            Expanded(flex: 8, child: screen),
          ],
        ),
      ),
    );
  }
}
