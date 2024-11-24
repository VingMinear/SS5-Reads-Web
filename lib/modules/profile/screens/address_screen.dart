import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/address_model.dart';
import 'package:homework3/modules/profile/screens/add_address_screen.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../controller/address_controller.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key, this.selectAddress = false});
  final con = Get.put(AddressController());
  final bool selectAddress;
  @override
  Widget build(BuildContext context) {
    con.getAddress();
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
          title: selectAddress ? 'Select your address' : 'Address',
          showNotification: false,
        ),
        backgroundColor: Colors.transparent,
        body: Obx(
          () {
            return con.loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : con.listAddress.isEmpty
                    ? const Center(child: Text('No Address found.'))
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(20),
                              itemCount: con.listAddress.length,
                              itemBuilder: (context, index) {
                                var item = con.listAddress[index];
                                return InkWell(
                                  onTap: () {
                                    if (selectAddress) {
                                      Navigator.pop(context, item);
                                    } else {
                                      showAlertDialog(
                                        barrierColor: Colors.transparent,
                                        content: AddAddressScreen(
                                          addNew: false,
                                          address: item,
                                        ),
                                      );
                                    }
                                  },
                                  child: buildAddress(item),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                            ),
                          ],
                        ),
                      );
          },
        ),
        // SlidableAction(
        //                 onPressed: (context) {

        //                 },
        //                 backgroundColor: Colors.red,
        //                 foregroundColor: Colors.white,
        //                 icon: Icons.delete,
        //                 label: 'Delete',
        //                 borderRadius:
        //                     const BorderRadius.horizontal(
        //                   left: Radius.circular(10),
        //                 ),
        //               ),
        //               SlidableAction(
        //                 onPressed: (context) {

        //                 },
        //                 backgroundColor: Colors.blue,
        //                 foregroundColor: Colors.white,
        //                 icon: Icons.edit,
        //                 label: 'Edit',
        //                 borderRadius:
        //                     const BorderRadius.horizontal(
        //                   right: Radius.circular(10),
        //                 ),
        //               ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomPrimaryButton(
            textValue: 'Add new address',
            textColor: Colors.white,
            onPressed: () async {
              showAlertDialog(
                barrierColor: Colors.transparent,
                content: AddAddressScreen(
                  addNew: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildAddress(AddressModel item) {
    var address =
        "${item.house},${item.commune},${item.district},${item.province}";
    return Stack(
      children: [
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: shadow,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                'assets/icons/map.png',
                width: 40,
              ),
              title: Text(
                "${item.receiverName} ${item.phoneNumber}",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                address,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton(
            tooltip: 'Option',
            padding: EdgeInsets.zero,
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            position: PopupMenuPosition.under,
            offset: const Offset(-15, -10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            itemBuilder: (context) {
              return List.generate(2, (index) {
                return PopupMenuItem(
                  onTap: () async {
                    await Future.delayed(Duration.zero);
                    switch (index) {
                      case 0:
                        showAlertDialog(
                          barrierColor: Colors.transparent,
                          content: AddAddressScreen(
                            addNew: false,
                            address: item,
                          ),
                        );
                        break;
                      case 1:
                        alertDialogConfirmation(
                          title: 'Are you sure?',
                          desc: 'You want to delete this address?',
                          onConfirm: () async {
                            await con.deleleAddress(item.id!);
                          },
                        );
                        break;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(index == 0 ? "Edit" : "Delete"),
                      SvgPicture.asset(
                        index == 0
                            ? "assets/icons/order/ic_pen.svg"
                            : "assets/icons/order/ic_delete.svg",
                      )
                    ],
                  ),
                );
              });
            },
            icon: const Icon(
              CupertinoIcons.ellipsis_vertical,
              color: Colors.black,
              size: 15,
            ),
          ),
        )
      ],
    );
  }
}
