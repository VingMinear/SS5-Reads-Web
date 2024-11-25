import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/profile/screens/edit_profile_screen.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_overlay.dart';

import '../../../utils/SingleTon.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    var user = GlobalClass().user;
    log("Pho ${user.value.photo}");

    return Obx(
      () => IntrinsicHeight(
        child: InkWell(
          onTap: () {
            removeOverlay();
            showAlertDialog(content: const EditProfileScreen());
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: CustomCachedNetworkImage(
                    imgUrl: user.value.photo.image.value,
                  ),
                ),
                const VerticalDivider(
                  color: Colors.grey,
                  width: 15,
                  endIndent: 3,
                  indent: 3,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.value.name ?? 'Unkown',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        user.value.email ?? "SS5@example.com",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
