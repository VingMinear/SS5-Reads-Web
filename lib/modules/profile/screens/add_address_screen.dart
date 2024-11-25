import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/address_model.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';
import 'package:homework3/widgets/input_field.dart';
import 'package:homework3/widgets/primary_button.dart';

import '../../../model/address.dart';
import '../../../widgets/google_map.dart';
import '../controller/address_controller.dart';

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({super.key, required this.addNew, this.address});
  final bool addNew;
  final AddressModel? address;
  final con = Get.put(AddressController());
  final mapCon = Get.put(MapController());
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        // mapCon.currentLocaton();
      },
    );
    var listTxtCon = List.generate(
      6,
      (index) => TextEditingController(),
    );
    if (address != null) {
      listTxtCon[0].text = address?.receiverName ?? '';
      listTxtCon[1].text = address?.phoneNumber ?? '';
      listTxtCon[2].text = address?.province ?? '';
      listTxtCon[3].text = address?.district ?? '';
      listTxtCon[4].text = address?.commune ?? '';
      listTxtCon[5].text = address?.house ?? '';
    }
    return Container(
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Scaffold(
        appBar: customAppBar(
          title: addNew ? "Add Address" : "Edit Address",
          showNotification: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // GetBuilder<MapController>(
              //   init: mapCon,
              //   builder: (controller) {
              //     return Stack(
              //       children: [
              //         Container(
              //           clipBehavior: Clip.hardEdge,
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(15),
              //             boxShadow: [
              //               BoxShadow(
              //                 blurRadius: 12,
              //                 color: Colors.grey.shade300,
              //               ),
              //             ],
              //             border: Border.all(
              //               width: 2,
              //               color: Colors.white,
              //             ),
              //           ),
              //           width: double.infinity,
              //           height: appHeight() * 0.25,
              //           child: FadeIn(
              //             child: Stack(
              //               children: [
              //                 ClipRRect(
              //                   clipBehavior: Clip.antiAlias,
              //                   borderRadius: BorderRadius.circular(15),
              //                   child: GoogleMap(
              //                     markers: {controller.marker.value},
              //                     zoomGesturesEnabled: false,
              //                     indoorViewEnabled: false,
              //                     rotateGesturesEnabled: false,
              //                     scrollGesturesEnabled: false,
              //                     trafficEnabled: false,
              //                     onMapCreated: (map) {
              //                       controller.smallMapController = map;
              //                     },
              //                     // mapToolbarEnabled: false,
              //                     zoomControlsEnabled: false,
              //                     compassEnabled: false,
              //                     padding: const EdgeInsets.all(10),
              //                     initialCameraPosition: CameraPosition(
              //                       target: controller.latLng,
              //                       zoom: 15,
              //                     ),
              //                   ),
              //                 ),
              //                 Positioned.fill(
              //                   child: BackdropFilter(
              //                     filter: ImageFilter.blur(
              //                       sigmaX: 40,
              //                       sigmaY: 40,
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //         Positioned.fill(
              //           child: GestureDetector(
              //             onTap: () {
              //               debugPrint("route");
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => const MyGoogleMap(),
              //                 ),
              //               ).then((value) {
              //                 listTxtCon[2].text =
              //                     controller.address.province ?? '';
              //                 listTxtCon[3].text =
              //                     controller.address.district ?? '';
              //                 listTxtCon[4].text =
              //                     controller.address.commune ?? '';
              //                 controller.moveSmallCamera(controller.latLng);
              //               });
              //             },
              //           ),
              //         )
              //       ],
              //     );
              //   },
              // ),
              // const SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Receiver Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildField(
                      title: 'Receiver Name',
                      controller: listTxtCon[0],
                      hintText: 'Full Name',
                    ),
                    buildField(
                      title: 'Phone Number',
                      controller: listTxtCon[1],
                      keyboardType: TextInputType.phone,
                      hintText: 'Your phone number',
                    ),
                    buildField(
                      title: 'Provice',
                      controller: listTxtCon[2],
                      hintText: 'Provice',
                    ),
                    buildField(
                      title: 'District',
                      controller: listTxtCon[3],
                      hintText: 'District',
                    ),
                    buildField(
                      required: false,
                      title: 'Commune (optional)',
                      controller: listTxtCon[4],
                      hintText: 'commune',
                    ),
                    buildField(
                      required: false,
                      title: 'House Name (optional)',
                      controller: listTxtCon[5],
                      hintText: 'House Name',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomPrimaryButton(
            textValue: 'Save',
            textColor: Colors.white,
            onPressed: () async {
              crudAddress(listTxtCon);
            },
          ),
        ),
      ),
    );
  }

  void crudAddress(List<TextEditingController> listTxtCon) {
    String name, ph, provice, district, commune, house;
    name = listTxtCon[0].text.trim();
    ph = listTxtCon[1].text.trim();
    provice = listTxtCon[2].text.trim();
    district = listTxtCon[3].text.trim();
    commune = listTxtCon[4].text.trim();
    house = listTxtCon[5].text.trim();

    var newAdd = Address(
      receiverName: name,
      commune: commune,
      district: district,
      house: house,
      ph: ph,
      province: provice,
      latitude: mapCon.latLng.latitude,
      longitude: mapCon.latLng.longitude,
    );
    if (name.isNotEmpty &&
        ph.isNotEmpty &&
        provice.isNotEmpty &&
        district.isNotEmpty) {
      if (addNew) {
        con.addAddress(newAdd);
      } else {
        con.updAddress(newAdd, address!.id!);
      }
    } else {
      alertDialog(desc: 'Please input all fields required *');
    }
  }
}

Widget buildField({
  required TextEditingController controller,
  required String title,
  TextInputType? keyboardType,
  String hintText = '',
  int? delay,
  bool readOnly = false,
  bool obSecure = false,
  Widget? suffixIcon,
  bool required = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FadeInLeft(
        from: 10,
        child: Row(
          children: [
            Text(title),
            Text(
              required ? " *" : '',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      FadeInLeft(
        from: 5,
        delay: const Duration(milliseconds: 150),
        child: InputField(
          animate: false,
          readOnly: readOnly,
          obscureText: obSecure,
          keyboardType: keyboardType,
          hintText: hintText,
          suffixIcon: suffixIcon,
          controller: controller,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
