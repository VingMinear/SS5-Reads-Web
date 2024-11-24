import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/change_pwd.dart';
import 'package:homework3/modules/profile/components/header.dart';
import 'package:homework3/modules/profile/screens/edit_profile_screen.dart';
import 'package:homework3/routes/routes.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_overlay.dart';

import 'address_screen.dart';
import 'contact_us.dart';
import 'order_screen.dart';

typedef ProfileOptionTap = void Function();

class ProfileOption {
  String title;
  String icon;
  Color? titleColor;
  ProfileOptionTap? onClick;
  Widget? trailing;

  ProfileOption({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor,
    this.trailing,
  });

  ProfileOption.arrow({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor = const Color(0xFF212121),
    this.trailing = const Image(
        image: AssetImage('assets/icons/profile/arrow_right@2x.png'),
        width: 10,
        height: 10),
  });
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static String _profileIcon(String last) => 'assets/icons/profile/$last';
  List get datas => <ProfileOption>[
        ProfileOption.arrow(
            title: 'Favorite', icon: 'assets/icons/light/heart@2x.png'),
        ProfileOption.arrow(title: 'Order', icon: _profileIcon('order.png')),
        ProfileOption.arrow(
            title: 'Address', icon: _profileIcon('location@2x.png')),
        ProfileOption(
          title: 'Logout',
          icon: _profileIcon('logout@2x.png'),
          titleColor: const Color(0xFFF75555),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0.8,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            const ProfileHeader(),
            Divider(
              color: Colors.grey.shade200,
              height: 5,
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: List.generate(
          datas.length,
          (index) {
            final data = datas[index];
            return FadeInLeft(
              from: 14,
              delay: Duration(milliseconds: 50 * index),
              child: _buildOption(context, index, data),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, ProfileOption data) {
    return ListTile(
      leading: Image.asset(
        data.icon,
        width: 15,
      ),
      minLeadingWidth: 15,
      title: Text(
        data.title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: data.titleColor),
      ),
      trailing: data.trailing,
      onTap: () {
        removeOverlay();
        switch (index) {
          case 0:
            router.go('/my-favorite');
            break;
          case 1:
            router.go('/my-order');
            break;
          case 2:
            showAlertDialog(
              content: AddressScreen(),
            );
            break;
          default:
            alertDialogConfirmation(
              title: "Logout",
              desc: "Are you sure you want to Logout ?",
              onConfirm: () {
                router.pop();
                logOut();
              },
            );
            break;
        }
      },
    );
  }
}
