import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/SingleTon.dart';
import '../../../widgets/CustomCachedNetworkImage.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var user = GlobalClass().user;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5)
            .copyWith(right: 0, top: 10),
        child: Row(
          children: [
            Visibility(
              visible: GlobalClass().isUserLogin,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CustomCachedNetworkImage(
                  imgUrl: user.value.photo,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      GlobalClass().isUserLogin
                          ? 'Welcome Back 👋'
                          : 'Hey welcome 👋',
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      GlobalClass().isUserLogin
                          ? (user.value.name ?? 'Unknown')
                          : 'Looking for books?',
                      style: const TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
