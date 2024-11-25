import 'package:flutter/material.dart';
import 'package:homework3/modules/admin/dashboard/components/menu_side.dart';

final GlobalKey<ScaffoldState> adminScaffoldKey = GlobalKey<ScaffoldState>();

class MainLayoutAdmin extends StatelessWidget {
  const MainLayoutAdmin({super.key, required this.screen});
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: adminScaffoldKey,
      body: SafeArea(
        child: Row(
          children: [
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
