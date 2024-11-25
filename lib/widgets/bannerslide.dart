import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/slide_model.dart';
import 'package:homework3/modules/home_screen/controller/home_controller.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({super.key});

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  int pageNum = 0;
  var con = Get.put(HomeController());
  @override
  void initState() {
    con.fetchslides();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          con.loading.value
              ? FadeInDown(
                  from: 10,
                  child: CarouselSlider.builder(
                    itemCount: 2,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          pageNum = index;
                        });
                      },
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: double.infinity,
                          height: 400,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffFBE9D7),
                                mainColor,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : con.slidesBanner.isEmpty
                  ? Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.error, color: Colors.grey),
                    )
                  : FadeInDown(
                      from: 10,
                      child: CarouselSlider.builder(
                        itemCount: con.slidesBanner.length,
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              pageNum = index;
                            });
                          },
                          height: 400,
                          viewportFraction: 1,
                          autoPlay: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          var slide = con.slidesBanner[index];
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                                  mainColor,
                                  mainColor.withOpacity(0.8),
                                ],
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CustomCachedNetworkImage(
                              imgUrl: slide.img.image.value,
                            ),
                          );
                        },
                      ),
                    ),
          const SizedBox(
            height: 10,
          ),
          if (con.slidesBanner.isNotEmpty)
            AnimatedSmoothIndicator(
              activeIndex: pageNum,
              count: con.slidesBanner.length,
              effect: WormEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: mainColor,
                dotColor: Colors.grey.shade300,
              ),
            )
        ],
      );
    });
  }
}
